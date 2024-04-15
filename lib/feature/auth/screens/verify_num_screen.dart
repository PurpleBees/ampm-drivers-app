import 'package:ampm_app/feature/auth/controllers/verify_num_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import '../../../const/app_text.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class VerifyNumScreen extends StatelessWidget {
  const VerifyNumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyNumController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 42.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///title
                    Text(
                      AppText.verifyNumTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.left,
                    ),

                    const SizedBox(
                      height: 10.0,
                    ),

                    ///subtitle
                    Text(
                      AppText.verifyNumSubtitle,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    const SizedBox(
                      height: 26.0,
                    ),

                    /// phone form field
                    SizedBox(
                      height: 70.0,
                      child: IntlPhoneField(
                        controller: controller.numController,
                        initialCountryCode: controller.initialCountryCode,
                        showCountryFlag: false,
                        keyboardType: TextInputType.phone,
                        textAlignVertical: TextAlignVertical.center,
                        onCountryChanged: controller.onCountryChanged,
                        onChanged: controller.onChanged,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        disableLengthCheck: false,
                        pickerDialogStyle: PickerDialogStyle(backgroundColor: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: const TextStyle(color: Colors.black, fontSize: 16.58, fontWeight: FontWeight.w300),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0,
                            horizontal: 5.0,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0XFFE76E20),
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// continue button
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.isPhoneNoValid) {
                        controller.signInWithOTP(controller.supabase);
                        FocusScope.of(context).unfocus();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFE76E20),
                        foregroundColor: const Color(0XFFFFFFFF)),
                    child: Obx(
                      () => controller.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
