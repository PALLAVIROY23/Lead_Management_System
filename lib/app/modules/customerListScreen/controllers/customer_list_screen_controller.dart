import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms/app/modules/customerListScreen/extension/customerListExtension.dart';
import 'package:record/record.dart';

import '../../../api/api_controller.dart';
import '../model/customerListModel.dart';

class CustomerListScreenController extends GetxController {
  ApiController apiController;
  GetStorage box = GetStorage();
  final Record = AudioRecorder(); // Create an instance of Record

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
  var filteredCustomerList = <LeadData>[].obs; // Add a reactive list for filtered results
  var searchQuery = ''.obs; // Add a reactive variable for the search query

  void updateSelectedService(String value) => selectedService.value = value;
  void updateSelectedCity(String value) => selectedCity.value = value;
  void updateSelectedSource(String value) => selectedSource.value = value;
  void updateSelectedStatus(String value) => selectedStatus.value = value;

  Future<void> fetchCustomerStatusList(String uid, String status) async {
    try {
      isLoading(true);  // Set loading to true at the start
      var data = await apiController.fetchCustomerStatusListApi(uid, status);
      customerStatusList.value = data;
      filteredCustomerList.value = customerStatusList.value.lead ?? []; // Initialize the filtered list
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
    String status = box.read('selectedStatus');
    print("FinalStatus=$status");
    fetchCustomerStatusList(uid, status);
    startRecording();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> hasPermission() async {
    final status = await Record.hasPermission();
    return status;
  }

  // Start recording
  Future<void> startRecording() async {
    // ... (existing code)
  }

  // Stop recording
  Future<void> stopRecording() async {
    // ... (existing code)
  }

  // Method to filter customer list based on search query
  void filterCustomerList(String query) {
    searchQuery.value = query; // Update search query

    if (query.isEmpty) {
      // If the query is empty, show all customers
      filteredCustomerList.value = customerStatusList.value.lead ?? [];
    } else {
      // Filter customers based on the query
      filteredCustomerList.value = customerStatusList.value.lead?.where((customer) {
        return customer.name?.toLowerCase().contains(query.toLowerCase()) ?? false ||
            customer.mobile!.contains(query);
      }).toList() ?? [];
    }
  }
}
