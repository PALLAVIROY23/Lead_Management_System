import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(
      () => SplashScreenController(apiController: ApiController()),
    );
  }
}
