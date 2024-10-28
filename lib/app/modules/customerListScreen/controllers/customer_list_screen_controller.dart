import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms/app/modules/customerListScreen/extension/customerListExtension.dart';
import 'package:lms/app/modules/home/extension/dashboard_extension.dart';
import 'package:record/record.dart';

import '../../../api/api_controller.dart';
import '../model/citiesModel.dart';
import '../model/customerListModel.dart';
import '../model/serviceModel.dart';
import '../model/sourceModel.dart';

class CustomerListScreenController extends GetxController {
  ApiController apiController;
  GetStorage box = GetStorage();
  final Record = AudioRecorder(); // Create an instance of Record

  CustomerListScreenController({required this.apiController});

  var selectedIndex = 0.obs;
  var selectedCity = Rx<CitiesData?>(null);
  var city = <CitiesData>[].obs;
  var selectedSource = Rx<SourceList?>(null);
  var sources = <SourceList>[].obs;
  var selectStatus = Rx<String?>(null);
  var status = <String>[].obs;
  var args = Get.arguments;
  final count = 0.obs;
  var isLoading = false.obs;  // Loading state
  var customerStatusList = CustomerStatusListModel().obs;  // Customer status list
  var filteredCustomerList = <LeadData>[].obs; // Add a reactive list for filtered results
  var searchQuery = ''.obs; // Add a reactive variable for the search query
  var errorMessage = ' '.obs;
  ScrollController scrollController = ScrollController();

  var selectedService = Rx<CustomerService?>(null);
  var serviceList = <CustomerService>[].obs;

  void updateSelectedService(CustomerService value) {
    selectedService.value = value;
  }

  void updateSelectedCity(CitiesData value) => selectedCity.value = value;
  void updateSelectedSource(SourceList value) => selectedSource.value = value;
  void updateSelectedStatus(String value) => selectStatus.value = value;

  @override
  void onInit() {
    super.onInit();
    String uid = box.read('userDetail')['uid'];
    String status = box.read('selectedStatus');
    print("FinalStatus=$status");
    fetchCustomerStatusList(uid, status);
    fetchServiceList();
    startRecording();
    fetchStatuses();
    fetchCitiesList();
    fetchSourceList();
  }

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

  Future<void> fetchStatuses() async {
    try {
      var dashboardData = await apiController.dashBoardApi('status');
      if (dashboardData.success == true) {
        status.clear();
        for (var lead in dashboardData.lead!) {
          if (lead.status != null) {
            status.add(lead.status!);
          }
        }
      } else {
        Get.snackbar('Error', dashboardData.msg ?? 'Failed to load statuses');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching statuses');
      print('Error: $e');
    }
  }

  Future<void> fetchServiceList() async {
    EasyLoading.show(status: "Loading..."); // Show loading indicator
    try {
      var serviceData = await apiController.fetchServiceListApi();

      if (serviceData.success == true) {
        // Ensure that services are not null before assigning
        serviceList.value = serviceData.services ?? [];
        print("PRINT SERVICE LIST>>>>>>> $serviceList");
      } else {
        EasyLoading.showError("${serviceData.msg ?? 'Failed to load services'}");
        print("PRINT ERROR>>>>>>>>>>>>> ${serviceData.msg}");
      }
    } catch (e) {
      // Log the error for debugging purposes
      print("Error occurred while fetching service list: $e");
      EasyLoading.showError("An unexpected error occurred: $e");
    } finally {
      EasyLoading.dismiss(); // Dismiss loading indicator in both success and error cases
    }
  }

Future<void>fetchCitiesList()async{
    EasyLoading.show(status: "Loading....");
    try{
      var cityData = await apiController.fetchCitiesListApi();
      if(cityData.success==true){
        city.value= cityData.cities ?? [];
            print("CITIES LIST>>>>>>>${city}");
      }else {
        EasyLoading.showError("${cityData.msg ?? "failed to load cities list"}");
      }

    }catch(e) {
      print("Error occurred while fetching service list: $e");
      EasyLoading.showError("An unexpected error occurred: $e");
    }
}

  Future<void> fetchSourceList() async {
    EasyLoading.show(status: "Loading....");
    try {
      // Fetch data from the API
      var sourceData = await apiController.fetchSourceListApi();

      // Check if the API call was successful
      if (sourceData.success == true) {
        // Update the sources observable with the fetched data
        sources.value = sourceData.source ?? [];
        print("SOURCELIST>>>>>>${sourceData.source}");

        // Display a success message if needed
        EasyLoading.dismiss();
      } else {
        // Show error message if the response was not successful
        EasyLoading.showError(sourceData.msg ?? "Failed to fetch source list");
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      EasyLoading.showError("An unexpected error occurred: $e");
    }
  }



  void onItemTapped(int index) {
    selectedIndex.value = index;
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


  void filterCustomerList(String query) {
    searchQuery.value = query;


    if (query.isEmpty) {
      filteredCustomerList.value = customerStatusList.value.lead ?? [];
    } else {
      filteredCustomerList.value = customerStatusList.value.lead?.where((customer) {
        return customer.name?.toLowerCase().contains(query.toLowerCase()) ?? false ||
            customer.mobile!.contains(query);
      }).toList() ?? [];
    }
  }
}
