import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms/app/api/api_controller.dart';
import '../../../data/constants.dart';
import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  ApiController apiController;
  GetStorage box = GetStorage();
  SplashScreenController({required this.apiController});
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      var storedUserDetails = box.read("userDetails");
      var token = box.read(Constants.TOKEN) ?? "";
      print("Token: $token");

      if (storedUserDetails == null || token.isEmpty) {
        print("Navigating to LOGIN_SCREEN");
        Get.offAllNamed(Routes.LOGIN_SCREEN);
      } else {
        try {
          var decodedUserDetails = jsonDecode(storedUserDetails);
          // Ensure decodedUserDetails is a List before assigning to Constants
          if (decodedUserDetails is Map<String, dynamic>) {
            Constants.userDetails = [
              decodedUserDetails['uid'],
              decodedUserDetails['userFullName'],
              decodedUserDetails['userType']
            ];
            print("Decoded User Details: ${Constants.userDetails}");
            print("Navigating to HOME");
            Get.offAllNamed(Routes.HOME);
          } else {
            throw Exception("Unexpected data format for userDetails.");
          }
        } catch (e) {
          print("Error decoding user details: $e");
          Get.offAllNamed(Routes.LOGIN_SCREEN); // If error, navigate to login
        }
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Method to increment count (optional)
  void increment() => count.value++;
}
