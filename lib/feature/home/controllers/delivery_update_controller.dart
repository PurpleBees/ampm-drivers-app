import 'dart:io';
import 'package:ampm_app/const/delivery_status.dart';
import 'package:ampm_app/extensions/on_date_time.dart';
import 'package:ampm_app/extensions/on_time_of_day.dart';
import 'package:ampm_app/feature/home/screens/home_screen.dart';
import 'package:ampm_app/services/internet_connection_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../const/app_text.dart';
import '../models/delivery_detail_model.dart';
import '../models/delivery_proof_model.dart';

class DeliveryUpdateController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final TextEditingController remarkController = TextEditingController();
  RxList<File> imageFiles = RxList<File>();
  RxString pickedImagePath = ''.obs;
  RxBool isLoaded = false.obs;
  RxBool isDelivered = false.obs;
  RxString deliveryStatus = ''.obs;
  RxString currentDate = DateTime.now().dateToFormat.obs;
  RxString currentTime = TimeOfDay.now().toFormat.obs;

  // DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  List<String> imgUrlStrings = [];
  InternetConnectionServices connectionServices = InternetConnectionServices();

  @override
  void onInit() {
    connectionServices.init(
        onDisconnect: (){
          if (Get.isSnackbarOpen) {
            Get.closeAllSnackbars();
          }
          Get.rawSnackbar(
            message: AppText.noConnectionError,
            backgroundColor: Colors.red,
          );
        },
    );
    super.onInit();
  }

  @override
  void onClose() {
    remarkController.dispose();
    connectionServices.close();
  }

  void changeDeliveryStatus(String? status) {
    deliveryStatus.value = status ?? '';
  }

  // //pick date
  // void selectDate() async {
  //   selectedDate = (await showDatePicker(
  //           context: Get.context!,
  //           firstDate: DateTime(2023),
  //           lastDate: DateTime.now())) ??
  //       DateTime.now();
  //   currentDate.value = selectedDate.dateToFormat;
  // }

  //pick time
  void selectTime() async {
    selectedTime = (await showTimePicker(
            context: Get.context!, initialTime: TimeOfDay.now())) ??
        TimeOfDay.now();
    currentTime.value = selectedTime.toFormat;
  }

  //pick image
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      pickedImagePath.value = pickedFile.path;
      imageFiles.add(File(pickedImagePath.value));
    }
  }

  //removeImage
  // void removeImage() {
  //   pickedImagePath.value = '';
  //   imageFiles.clear();
  // }

  //update data
  Future<void> updateDelivery(DeliveryDetailModel detail) async {
    if (await connectionServices.hasConnection()) {
      isLoaded.value = true;
      try {
        // await _uploadTheImage(detail);
        await _updateDeliveryStatus(detail);
        // await _addDeliveryProof(detail);

        if (deliveryStatus.value != DeliveryStatus.delivered.name) {
          Get.offAll(() => const HomeScreen());
        }
        isLoaded.value = false;
      } catch (e) {
        debugPrint('$e');
        isLoaded.value = false;
      }
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.rawSnackbar(
        message: AppText.noConnectionError,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> updateDeliveryImages(DeliveryDetailModel detail) async {
    if (await connectionServices.hasConnection()) {
      isLoaded.value = true;
      try {
        await _uploadTheImage(detail);
        await _addDeliveryProof(detail);

        if (deliveryStatus.value.isNotEmpty) {
          Get.offAll(() => const HomeScreen());
        }
        isLoaded.value = false;
      } catch (e) {
        debugPrint('$e');
        isLoaded.value = false;
      }
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.rawSnackbar(
        message: AppText.noConnectionError,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _uploadTheImage(DeliveryDetailModel detail) async {
    if (imageFiles.isNotEmpty &&
        deliveryStatus.value == DeliveryStatus.delivered.name) {
      for (final file in imageFiles) {
        final String imagePath =
            '${detail.trackingNo}/${DateTime.timestamp()}.jpg';
        await _supabase.storage
            .from(AppText.bucketName)
            .upload(imagePath, file);
        final imgUrlString =
            _supabase.storage.from(AppText.bucketName).getPublicUrl(imagePath);
        imgUrlStrings.add(imgUrlString);
      }
    }
  }

  Future<void> _updateDeliveryStatus(
    DeliveryDetailModel detail,
  ) async {
    if (deliveryStatus.value.isNotEmpty) {
      await _supabase
          .from(AppText.runsheets)
          .update({
            'status': deliveryStatus.value,
            'delivered_at': DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day, selectedTime.hour, selectedTime.minute)
                .toTimeStamp,
            'notes': remarkController.text.trim().isEmpty
                ? null
                : remarkController.text.toString()
          })
          .eq('tracking_no', detail.trackingNo)
          .select()
          .then((value) {
            if (deliveryStatus.value == DeliveryStatus.delivered.name) {
              isDelivered.value = true;
            }
          });
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.rawSnackbar(
        message: AppText.verifyStatusMsg,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _addDeliveryProof(DeliveryDetailModel detail) async {
    if (imgUrlStrings.isNotEmpty &&
        deliveryStatus.value == DeliveryStatus.delivered.name) {
      await _removeExistingProof(detail.id);
      await _supabase.from(AppText.deliveryProofs).insert([
        DeliveryProofModel(
                timeStamp: DateTime.timestamp().toString(),
                runSheetId: detail.id,
                imgUrl: imgUrlStrings.toString())
            .toMap()
      ]);
    }
  }

  Future<void> _removeExistingProof(int runSheetId) async {
    try{
      final data = await _supabase
          .from(AppText.deliveryProofs)
          .select('runsheet_id')
          .eq('runsheet_id', runSheetId);
      if (data.isEmpty) {
        return;
      } else {
        await _supabase
            .from(AppText.deliveryProofs)
            .delete()
            .eq('runsheet_id', runSheetId);
      }
    }catch(e){
      debugPrint('$e');
    }
  }
}
