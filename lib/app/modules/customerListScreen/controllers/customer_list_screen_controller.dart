import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms/app/api/api_controller.dart';
import 'package:lms/app/modules/customerListScreen/extension/customerListExtension.dart';

import '../model/customerListModel.dart';

class CustomerListScreenController extends GetxController {
 ApiController apiController;
 GetStorage box = GetStorage();


 CustomerListScreenController({required this.apiController});

 var selectedIndex = 0.obs;
 var selectedService = 'Website'.obs;
 var selectedCity = 'Patna'.obs;
 var selectedSource = 'Just Dial'.obs;
 var selectedStatus = 'Open'.obs;
 var args = Get.arguments;
 final count = 0.obs;
 List<String> services = ['Website', 'Android App', 'AMC'];
 List<String> cities = ['Patna', 'Gaya', 'Bhagalpur', 'Muzaffarpur'];
 List<String> sources = ['Just Dial', 'Google', 'AMC'];
 List<String> statuses = ['Open', 'Ringing', 'Not Interested', 'Switch Off'];

 var isLoading = false.obs;  // Loading state
 var customerStatusList = CustomerStatusListModel().obs;  // Customer status list

 // Update the selected filters
 void updateSelectedService(String value) => selectedService.value = value;
 void updateSelectedCity(String value) => selectedCity.value = value;
 void updateSelectedSource(String value) => selectedSource.value = value;
 void updateSelectedStatus(String value) => selectedStatus.value = value;

 // Fetch the customer status list from the API
 Future<void> fetchCustomerStatusList(String uid, String status) async {
   try {
     isLoading(true);  // Set loading to true at the start
     var data = await apiController.fetchCustomerStatusListApi(uid, status);

     customerStatusList.value = data;
     print("listOfData>>>>>>${customerStatusList.value.lead}");
   } catch (e) {
     print("Error fetching status list: $e");
   } finally {
     isLoading(false);
   }
 }

 void onItemTapped(int index) {
   selectedIndex.value = index;
 }

 @override
 void onInit() {
   super.onInit();

   String uid = box.read('userDetail')['uid'];
   String status =  box.read('selectedStatus');
   print("Finalsatatus=$status");
   fetchCustomerStatusList(uid, status);
 }

 @override
 void onReady() {
   super.onReady();
 }

 @override
 void onClose() {
   super.onClose();
 }
}
