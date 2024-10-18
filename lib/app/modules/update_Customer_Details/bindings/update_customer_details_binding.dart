import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';

import '../controllers/update_customer_details_controller.dart';

class UpdateCustomerDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateCustomerDetailsController>(
      () => UpdateCustomerDetailsController(apiController: ApiController()),
    );
  }
}
