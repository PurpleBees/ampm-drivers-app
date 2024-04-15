import 'dart:async';
import 'package:ampm_app/const/app_text.dart';
import 'package:ampm_app/feature/auth/screens/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VerifyNumController extends GetxController {
  final TextEditingController numController = TextEditingController();
  final String initialCountryCode = 'IN';
  final SupabaseClient supabase = Supabase.instance.client;
  RxBool isLoading = false.obs;
  late Country currentCountry;

  @override
  void onInit() {
    currentCountry = countries
        .firstWhere((Country country) => country.code == initialCountryCode);
    super.onInit();
  }
  @override
  void onClose() {
    numController.dispose();
    super.onClose();
  }

  void onCountryChanged(Country country) {
    currentCountry = country;
  }

  void onChanged(PhoneNumber phoneNumber) {
    if (phoneNumber.number.isEmpty ||
        !RegExp(r'^\d+$').hasMatch(phoneNumber.number)) {
      numController.text = numController.text.replaceAll(RegExp(r'[^0-9]'), '');
    }
  }

  bool get isPhoneNoValid {
    if (numController.text.length >= currentCountry.minLength &&
        numController.text.length <= currentCountry.maxLength) {
      return true;
    }
    return false;
  }

  Future<bool?> signInWithOTP(SupabaseClient supabase) async {
    isLoading.value = true;
    try{
      await supabase.auth.signInWithOtp(
          phone: '+${currentCountry.dialCode}${numController.text}').then((value){
        isLoading.value = false;
        Get.to(() => VerifyOTPScreen(phoneNumber: '+${currentCountry.dialCode}${numController.text}',));
      });
    }catch(e){
      debugPrint('$e');
      Get.rawSnackbar(message: AppText.numErrorMessage, backgroundColor: Colors.red);
      isLoading.value = false;
      return false;
    }
    return null;
  }
}
