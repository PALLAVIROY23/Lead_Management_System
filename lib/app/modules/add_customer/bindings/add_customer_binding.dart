import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';

import '../controllers/add_customer_controller.dart';

class AddCustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCustomerController>(
      () => AddCustomerController(apiController: ApiController()),
    );
  }
}
