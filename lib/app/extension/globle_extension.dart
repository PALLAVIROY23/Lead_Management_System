import 'package:get/get.dart';
import '../api/api_controller.dart';


extension CustomBinding on Bindings{
  ApiController get apiController => Get.find<ApiController>();
}