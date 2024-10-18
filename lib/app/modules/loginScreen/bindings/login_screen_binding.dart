import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';

import '../controllers/login_screen_controller.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginScreenController>(
      () => LoginScreenController(apiController: ApiController()),
    );
  }
}
