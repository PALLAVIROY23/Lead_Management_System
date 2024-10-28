import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';
import 'package:intl/intl.dart';
import 'package:lms/app/modules/add_customer/extension/addCustomerExtension.dart';
import 'package:lms/app/modules/customerListScreen/extension/customerListExtension.dart';
import 'package:lms/app/modules/home/extension/dashboard_extension.dart';
import 'package:lms/app/routes/app_pages.dart';

import '../../customerListScreen/model/citiesModel.dart';
import '../../customerListScreen/model/serviceModel.dart';
import '../../customerListScreen/model/sourceModel.dart';

class AddCustomerController extends GetxController {
  final ApiController apiController;

  AddCustomerController({required this.apiController});

  // Text Controllers for form fields
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController alternateMobileNumber = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();

  // Observable variables for dropdowns and date
  var selectedService = Rx<CustomerService?>(null);
  var serviceList = <CustomerService>[].obs;
  var selectedStatus = Rx<String?>(null);
  var status = <String>[].obs;
  var selectedCity = Rx<CitiesData?>(null);
  var city = <CitiesData>[].obs;
  var selectedSource = Rx<SourceList?>(null);
  var sources = <SourceList>[].obs;
  var selectedDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchStatuses();
    fetchSourceList();
    fetchServiceList();
    fetchCitiesList();


  }

  // Fetch the list of statuses from API
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

  void updateSelectedService(CustomerService value) {
    selectedService.value = value;
  }
  void updateSelectedCity(CitiesData value) => selectedCity.value = value;
  void updateSelectedSource(SourceList value) => selectedSource.value = value;

  void updateSelectedStatus(String? newValue) {
      selectedStatus.value = newValue;
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



  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        selectedDate.value = selectedDateTime;
      }
    }
  }
  String get formattedDate => selectedDate.value != null
      ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDate.value!)
      : 'Follow Up Date';
  // Validate form fields
  bool validateFields() {
    if (customerNameController.text.isEmpty) {
      EasyLoading.showError('Customer name is required');
      return false;
    }
    if (mobileNumber.text.isEmpty) {
      EasyLoading.showError('Mobile number is required');
      return false;
    }
    if (!GetUtils.isPhoneNumber(mobileNumber.text)) {
      EasyLoading.showError('Invalid mobile number');
      return false;
    }
    if (emailController.text.isNotEmpty && !GetUtils.isEmail(emailController.text)) {
      EasyLoading.showError('Invalid email address');
      return false;
    }
    if (selectedDate.value == null) {
      EasyLoading.showError('Please select a follow-up date');
      return false;
    }
    return true;
  }


  Future<void> saveCustomer() async {
    if (validateFields()) {
      try {
        // Show loading indicator
        Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);

        // Call the API to save customer data
        var response = await apiController.addCustomer(
          name: customerNameController.text,
          email: emailController.text,
          mobile: mobileNumber.text,
          alternatemobile: alternateMobileNumber.text,
          companyname: companyNameController.text,
          websiteurl: '',
          address: '',
          userassigned: '',
          status: selectedStatus.string,
          followupdate: formattedDate,
          lastupdate: formattedDate,
          comments: '',
          industry: '',
          city: selectedCity.string,
          source: selectedSource.string,
          service: selectedService.string,
        );
        print("ADD CUSTOMER>>>>>>>${response}");
        Get.toNamed(Routes.HOME);

        // Check if the API response indicates success
        if (response['success'] == true) {
          EasyLoading.showSuccess("Customer added successfully");
          resetForm();
        } else {
          Get.snackbar('Error', response['message'] ?? 'Failed to add customer');
        }
      } catch (e) {
        Get.back();
        Get.snackbar('Error', 'Failed to add customer');
        print('Error: $e');
      }
    }
  }


  void resetForm() {
    customerNameController.clear();
    mobileNumber.clear();
    alternateMobileNumber.clear();
    emailController.clear();
    companyNameController.clear();
    selectedService.value = null;
    selectedStatus.value = null;
    selectedCity.value = null;
    selectedSource.value = null;
    selectedDate.value = null;
  }

}
