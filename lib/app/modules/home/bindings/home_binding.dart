import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(apiController: ApiController()),
    );
  }
}
