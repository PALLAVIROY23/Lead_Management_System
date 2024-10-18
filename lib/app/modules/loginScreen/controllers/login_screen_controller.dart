import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms/app/modules/loginScreen/extension/login_extension.dart';

import '../../../api/api_controller.dart';
import '../../../data/constants.dart';
import '../../../routes/app_pages.dart';

class LoginScreenController extends GetxController {
  ApiController apiController;
  GetStorage box = GetStorage();
  LoginScreenController({required this.apiController});

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  RxBool isLogin = false.obs;
  final count = 0.obs;
  final buttonPosition = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  // Handle login button tap
  void onLoginTap() {
    if (username.text.isEmpty) {
      EasyLoading.showError('Please enter your username');
      return;
    } else if (password.text.isEmpty) {
      EasyLoading.showInfo('Please enter your password');
      return;
    } else {
      login(username.text, password.text); // Call login method
    }
  }

  // Method to perform login operation
  void login(String username, String password) async {
    EasyLoading.show(status: "Logging in..."); // Show loading indicator

    // Call API to login
    var response = await apiController.loginWithUserName(username, password);

    EasyLoading.dismiss(); // Dismiss loading indicator

    if (response.success ?? false) {
      // Success case
      print("Login successful, data is loaded");
      EasyLoading.showSuccess("${response.msg}");

      // Store the token in GetStorage
      await apiController.getStorage.write(Constants.TOKEN, response.userdetail);

      // Store user details in JSON format
      final userDetails = {
        "uid": response.userdetail?.id,            // Access uid from response
        "userFullName": response.userdetail?.userfullname,  // Access user full name
        "userType": response.userdetail?.usertype,  // Access user type
      };

      // Convert userDetails map to JSON string
      String userDetailsJson = jsonEncode(userDetails);
      box.write('userDetail', userDetails);
      print("USERDETAIL :$userDetails");
      // Serialize user details and store as String
      await apiController.getStorage.write(Constants.TOKEN, userDetailsJson);

      // Navigate to home screen
      Get.offAllNamed(Routes.HOME);

    } else {
      // Error case
      EasyLoading.showError("${response.msg}");
    }
  }

  @override
  void onClose() {
    username.dispose();
    password.dispose();
    super.onClose();
  }
}
