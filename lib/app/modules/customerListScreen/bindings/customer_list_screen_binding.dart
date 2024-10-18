import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';

import '../controllers/customer_list_screen_controller.dart';

class CustomerListScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerListScreenController>(
      () => CustomerListScreenController(apiController: ApiController()),
    );
  }
}
