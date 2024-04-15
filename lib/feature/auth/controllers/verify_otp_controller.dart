import 'package:ampm_app/feature/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../const/app_text.dart';

class VerifyOTPController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final OTPTextEditController otpController =
      OTPTextEditController(codeLength: 6, otpInteractor: OTPInteractor())
        ..startListenUserConsent((code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        });

  RxBool isLoading = false.obs;

  @override
  void onClose(){
    otpController.dispose();
  }

  Future<void> verifyOTP(String otp, String phoneNumber) async {
    isLoading.value = true;
    try {
      await _supabase.auth
          .verifyOTP(
        token: otp,
        type: OtpType.sms,
        phone: phoneNumber,
      )
          .then((value) {
            Get.off(() => const HomeScreen());
        isLoading.value = false;
      });
    } catch (e) {
      debugPrint('e');
      isLoading.value = false;
      if (Get.isSnackbarOpen) {
        Get.closeAllSnackbars();
      }
      Get.rawSnackbar(
        message: AppText.otpValidationMsg,
        backgroundColor: Colors.red,
      );
    }

  }

  void onChanged(String otp) {
    if (otp.isEmpty || !RegExp(r'^\d+$').hasMatch(otp)) {
      otpController.text = otpController.text.replaceAll(RegExp(r'[^0-9]'), '');
    }
  }

  String? validator(String? otp) {
    if ((otp ?? '').length < 6) {
      return AppText.otpValidationMsg;
    }
    return null;
  }
}
