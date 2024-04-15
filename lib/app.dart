import 'package:ampm_app/const/app_colors.dart';
import 'package:ampm_app/const/text_theme.dart';
import 'package:ampm_app/feature/auth/screens/verify_num_screen.dart';
import 'package:ampm_app/feature/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show GetMaterialApp;
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  bool isLoggedIn() {
    final SupabaseClient supabase = Supabase.instance.client;
    if (supabase.auth.currentUser == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: AppTextTheme.textTheme,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surfaceTint: Colors.white,
        ),
      ),
      home: isLoggedIn() ? const HomeScreen() : const VerifyNumScreen(),
    );
  }
}
