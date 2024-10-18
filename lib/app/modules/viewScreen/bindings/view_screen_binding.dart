import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';

import '../controllers/view_screen_controller.dart';

class ViewScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ViewScreenController>(
      () => ViewScreenController(apiController: ApiController()),
    );
  }
}
