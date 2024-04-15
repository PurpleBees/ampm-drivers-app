import 'dart:io';
import 'dart:typed_data';

import 'package:ampm_app/extensions/on_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../const/app_text.dart';
import '../../../const/delivery_status.dart';
import '../../../services/internet_connection_services.dart';
import '../models/delivery_detail_model.dart';
import '../models/delivery_proof_model.dart';
import '../screens/home_screen.dart';

class DeliveryDetailController extends GetxController {
  final int runSheetId;
  final String trackingNo;

  DeliveryDetailController(this.runSheetId, this.trackingNo);

  RxBool isLoading = true.obs;
  final SupabaseClient _supabase = Supabase.instance.client;

  RxList<ImageProvider> imageProviders = RxList<ImageProvider>();
  Map<int, File> imageFiles = {};
  List<String> imageUrls = [];

  InternetConnectionServices connectionServices = InternetConnectionServices();

  @override
  void onInit() async {
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
    if(await connectionServices.hasConnection()){
      await getDeliveryImagesUploaded(trackingNo, runSheetId, _supabase)
          .then((List<String> images) async {
        imageUrls = images;
        for (int i = 0; i < images.length; i++) {
          imageProviders.add(NetworkImage(images[i]));
        }
      });
    }else{
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.rawSnackbar(
        message: AppText.noConnectionError,
        backgroundColor: Colors.red,
      );

    }

    super.onInit();
  }

  @override
  void onClose(){
    connectionServices.close();
  }

  //pick image
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      imageProviders.add(FileImage(imageFile));
      imageFiles[imageProviders.length - 1] = imageFile;
    }
  }

  Future<void> _uploadTheImage(DeliveryDetailModel detail) async {
    if (imageFiles.isNotEmpty) {
      for (final file in imageFiles.values) {
        final String imagePath =
            '${detail.trackingNo}/${DateTime.timestamp()}.jpg';
        await _supabase.storage
            .from(AppText.bucketName)
            .upload(imagePath, file);
        final imgUrlString =
            _supabase.storage.from(AppText.bucketName).getPublicUrl(imagePath);
        imageUrls.add(imgUrlString);
      }
    }
  }

  //removeImage
  void removeImage(int index) {
    imageProviders.removeAt(index);
    imageFiles.remove(index);
    debugPrint('${imageFiles.length}');
  }

  Future<List<String>> getDeliveryImagesUploaded(
      String trackingNo, int deliveryId, SupabaseClient supabase) async {
    try {
      final data = await supabase
          .from(AppText.deliveryProofs)
          .select('image_url')
          .eq('runsheet_id', deliveryId)
          .limit(1)
          .single();
      debugPrint('$data');
      final rowData = data['image_url'].toString();
      final list = rowData.stringToList;
      isLoading.value = false;
      return list;
    } catch (e) {
      debugPrint('Error on get delivery images : $e');
      isLoading.value = false;
      return [];
    }
  }

  Future<void> updateDeliveryImages(DeliveryDetailModel detail) async {
    if (await connectionServices.hasConnection()) {
      isLoading.value = true;
      try {
        await _uploadTheImage(detail);
        await _addDeliveryProof(detail);


          Get.offAll(() => const HomeScreen())?.then((value) => isLoading.value = false);


      } catch (e) {
        debugPrint('$e');
        isLoading.value = false;
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

  Future<void> _addDeliveryProof(DeliveryDetailModel detail) async {
    if (imageUrls.isNotEmpty) {
      await _removeExistingProof(detail.id);
      await _supabase.from(AppText.deliveryProofs).insert([
        DeliveryProofModel(
          timeStamp: DateTime.timestamp().toString(),
          runSheetId: detail.id,
          imgUrl: imageUrls.toString(),
        ).toMap()
      ]);
    }
  }

  Future<void> _removeExistingProof(int runSheetId) async {
    try {
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
    } catch (e) {
      debugPrint('$e');
    }
  }
}
