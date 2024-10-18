import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.count;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Lottie animation
          Lottie.asset(
            'assets/animations/backGroundScreen.json',
            fit: BoxFit.cover, // Ensures the animation covers the full screen
            width: double.infinity,
            height: double.infinity,
          ),
          // Centered Image
          Center(
            child: Image(
              image: const AssetImage("assets/images/Lms-preview.png"),
              height: 400.h,
              width: 280.w,
            ),
          ),
        ],
      ),
    );
  }
}
