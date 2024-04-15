import 'package:ampm_app/const/delivery_status.dart';
import 'package:ampm_app/extensions/on_date_time.dart';
import 'package:ampm_app/feature/auth/screens/verify_num_screen.dart';
import 'package:ampm_app/feature/home/models/delivery_detail_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../const/app_text.dart';
import '../../../services/internet_connection_services.dart';

class HomeController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  RxString firstName = 'Your'.obs;
  RxString lastName = 'Name'.obs;
  RxString title = AppText.nextDeliveriesTitle.obs;
  InternetConnectionServices connectionServices = InternetConnectionServices();

  final startOfDay = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  final endOfDay = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 23, 59, 59);

  @override
  void onInit() async {
    connectionServices.init(
      onDisconnect: () {
        if (Get.isSnackbarOpen) {
          Get.closeAllSnackbars();
        }
        Get.rawSnackbar(
          message: AppText.noConnectionError,
          backgroundColor: Colors.red,
        );
      },
    );
    title.value = AppText.nextDeliveriesTitle;
    await getName();
    super.onInit();
  }

  @override
  void onClose() {
    connectionServices.close();
  }

  void changeTitle(String newTitle) {
    if (title.value == newTitle) {
      Get.back();
      return;
    }
    title.value = newTitle;
    Get.back();
  }

  void logout() {
    _supabase.auth.signOut();
    Get.offAll(() => const VerifyNumScreen());
  }

  Future<void> getName() async {
    debugPrint('run');
    try {
      final String id = _supabase.auth.currentUser!.id;

      final Map<String, dynamic> nameData = await _supabase
          .from(AppText.persons)
          .select('first_name, last_name')
          .eq('user_id', id)
          .limit(1)
          .single();

      firstName.value = nameData['first_name'];
      lastName.value = nameData['last_name'];
    } catch (e) {
      debugPrint('Error on getting nameData : $e');
    }
  }

  Future<List<Map<String, dynamic>>?> getNextDeliveriesData() async {
    try {
      final blockId = await getBlockId(_supabase.auth.currentUser!.id);
      final data = _supabase
          .from(AppText.runsheets)
          .select(
              'tracking_no, consignee_name, dropoff_address, packages, id, status, created_at, notes, delivered_at')
          .eq('block_id', blockId)
          .eq('status', DeliveryStatus.outForDelivery.name)
          .limit(50);
      return data;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getCompletedDeliveriesData() async {
    try {
      final blockId = await getBlockId(_supabase.auth.currentUser!.id);

      final data = _supabase
          .from(AppText.runsheets)
          .select(
              'tracking_no, consignee_name, dropoff_address, packages, id, status, created_at, notes, delivered_at')
          .eq('block_id', blockId)
          .or('status.eq.${DeliveryStatus.delivered.name}, status.eq.${DeliveryStatus.failed.name}, status.eq.${DeliveryStatus.rejected.name}');
      return data;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  Future<int> getBlockId(String userId) async {
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final blockId = await _supabase
          .from(AppText.blocks)
          .select('id')
          .eq('user_id', userId)
          .eq('run_date', todayDate)
          .limit(1)
          .single();
      return blockId['id'];
    } catch (e) {
      return 0;
    }
  }
}
