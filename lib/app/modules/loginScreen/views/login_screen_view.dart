import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../customWidgets/CustomTextField.dart';
import '../../../../customWidgets/color_extension.dart';
import '../controllers/login_screen_controller.dart';

class LoginScreenView extends GetView<LoginScreenController> {
  const LoginScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image(
                image: const AssetImage("assets/images/Lms-preview.png"),
                height: 350.h,
                width: 200.w,
              ),
            ),
            Text(
              "Welcome to LMS",
              style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w500),
            ).paddingOnly(right: 140),
            Text(
              "Login!",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700,color: HexColor.fromHex("#1D4288")),
            ).paddingOnly(right: 260),
            SizedBox(height: 25.h),
            CustomTextField(
                HintText: "username",
                Radius: 10,
                width: 400.w,
                keyboardType: TextInputType.name,
                obscureText: false,
                isOutlineInputBorder: true,
                controller: controller.username,
                decoration: BoxDecoration(color: Colors.grey.shade100,)
            ).paddingSymmetric(horizontal: 25),
            SizedBox(height: 15.h),
            CustomTextField(
                HintText: "Password",
                Radius: 10,
                width: 400.w,
                obscureText: true,
                isOutlineInputBorder: true,
                controller: controller.password,
                keyboardType: TextInputType.text,
                decoration: BoxDecoration(color: Colors.grey.shade100,)
            ).paddingSymmetric(horizontal: 25),
            SizedBox(height: 55.h),
            myButton(
                onTap: () {
                  controller.onLoginTap();
                },
                height: 53.h,
                width: 400.w,
                text: "Login",
                textcolor: Colors.white,
                Color:HexColor.fromHex("#1D4288")
            ).paddingSymmetric(horizontal: 25.w),
            SizedBox(height: 30.h),


          ],
        ),

      ).paddingSymmetric(vertical: 15),
    );
  }
}
Widget myButton({
  String? text,
  void Function()? onTap,
  Color? Color,
  Color? textcolor,
  double? height,
  double? width,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height ?? Get.height * 0.05,
      width: width ?? Get.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          text == null
              ? SizedBox()
              : Text(
            text,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textcolor),
          ),
        ],
      ),
    ),
  );
}
