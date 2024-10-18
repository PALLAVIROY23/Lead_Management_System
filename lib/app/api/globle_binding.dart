
import 'package:get/get.dart';

import 'api_controller.dart';




class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiController>(() => ApiController());

  }
}