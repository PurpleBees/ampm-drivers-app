import 'package:ampm_app/const/app_text.dart';
import 'package:ampm_app/feature/auth/controllers/verify_otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class VerifyOTPScreen extends StatelessWidget {
  final String? phoneNumber;

  const VerifyOTPScreen({
    super.key,
    this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyOTPController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40.0, right: 40.0, top: 42.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //title
                        Text(
                          AppText.verifyOTPTitle,
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
              
                        //subtitle
                        Text(
                          AppText.verifyOTPSubtitle,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
              
                        //phone no
                        Text(
                          phoneNumber ?? '+91 8320760092',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 7.0,
                        ),
              
                        //code input field
                        Pinput(
                          controller: controller.otpController,
                          onChanged: controller.onChanged,
                          validator: controller.validator,
                          errorTextStyle: const TextStyle(color: Colors.red, ),
                          length: 6,
                          defaultPinTheme: PinTheme(
                            width: 50.0,
                            textStyle: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 50.0,
                            textStyle: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: const Color(0XFFE76E20)),
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 20.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(controller.formKey.currentState!.validate()){
                            debugPrint('hi');
                            controller.verifyOTP(controller.otpController.text.toString(), phoneNumber ?? '');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFFE76E20),
                            foregroundColor: const Color(0XFFFFFFFF)),
                        child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
              
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
