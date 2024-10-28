import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';
import 'package:lms/app/modules/customerListScreen/extension/customerListExtension.dart';
import 'package:lms/app/modules/update_Customer_Details/extension/update_customer_extension.dart';

import '../../customerListScreen/model/citiesModel.dart';
import '../../customerListScreen/model/serviceModel.dart';
import '../../customerListScreen/model/sourceModel.dart';

class UpdateCustomerDetailsController extends GetxController {
  final ApiController apiController;

  UpdateCustomerDetailsController({required this.apiController});

  var selectedService = Rx<CustomerService?>(null);
  var serviceList = <CustomerService>[].obs;
  var selectedCity = Rx<CitiesData?>(null);
  var city = <CitiesData>[].obs;
  var selectedSource = Rx<SourceList?>(null);
  var sources = <SourceList>[].obs;

  // TextEditingController for customer details
  TextEditingController customerName = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController alternateMobileNumber = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController websiteUrl = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController userAssigned = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController followUpdate = TextEditingController();
  TextEditingController lastUpdate = TextEditingController();
  TextEditingController comments = TextEditingController();
  TextEditingController industry = TextEditingController();



  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      final arguments = Get.arguments as Map<String, dynamic>;
      customerName.text = arguments['name'] ?? '';
      emailController.text = arguments['address'] ?? ''; // Assuming 'address' represents the email
      mobileNumber.text = arguments['mobile'] ?? '';
      alternateMobileNumber.text = arguments['alternatemobile'] ?? '';
      companyName.text = arguments['companyname'] ?? '';
    }
    fetchSourceList();
    fetchServiceList();
    fetchCitiesList();

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose of controllers to prevent memory leaks
    customerName.dispose();
    emailController.dispose();
    mobileNumber.dispose();
    alternateMobileNumber.dispose();
    companyName.dispose();
    websiteUrl.dispose();
    address.dispose();
    userAssigned.dispose();
    status.dispose();
    followUpdate.dispose();
    lastUpdate.dispose();
    comments.dispose();
    industry.dispose();
    super.onClose();
  }

  void increment() => count.value++;



// Variables to hold error messages for each field
  final RxString customerNameError = ''.obs;
  final RxString emailError = ''.obs;
  final RxString mobileNumberError = ''.obs;
  final RxString companyNameError = ''.obs;

// Function to validate inputs and set error messages
  bool validateInputs() {
    bool isValid = true;

    // Reset error messages
    customerNameError.value = '';
    emailError.value = '';
    mobileNumberError.value = '';
    companyNameError.value = '';

    // Check each field and set the appropriate error message
    if (customerName.text.isEmpty) {
      customerNameError.value = "Enter Customer name";
      isValid = false;
    }

    if (emailController.text.isEmpty &&
        !GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Invalid email address';
      isValid = false;
    }

    if (mobileNumber.text.isEmpty) {
      mobileNumberError.value = 'Mobile number is required';
      isValid = false;
    }

    if (companyName.text.isEmpty) {
      companyNameError.value = "Enter Company Name";
      isValid = false;
    }

    return isValid;
  }
  void updateSelectedService(CustomerService value) {
    selectedService.value = value;
  }
  void updateSelectedCity(CitiesData value) => selectedCity.value = value;
  void updateSelectedSource(SourceList value) => selectedSource.value = value;

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

// Function to update customer details
  Future<void> updateCustomerDetails() async {
    if (validateInputs()) {
      try {
        final response = await apiController.updateCustomer(
          name: customerName.text,
          email: emailController.text,
          mobile: mobileNumber.text,
          alternatemobile: alternateMobileNumber.text,
          companyname: companyName.text,
          websiteurl: websiteUrl.text,
          address: address.text,
          userassigned: userAssigned.text,
          status: selectedService.string,
          followupdate: followUpdate.text,
          lastupdate: lastUpdate.text,
          comments: comments.text,
          industry: industry.text,
          source: selectedSource.string,
          service: selectedService.string,
          city: selectedCity.string,
        );

        if (response['success']) {
          EasyLoading.showSuccess("Updated Successfully");
          Get.back();
          clearTextFields();
        } else {
          EasyLoading.showError(response['message'] ?? "Failed to update customer");
        }
      } catch (e) {
        EasyLoading.showError("An error occurred: ${e.toString()}");
      }
    }
  }


  // Clear all text fields after successful update
  void clearTextFields() {
    customerName.clear();
    emailController.clear();
    mobileNumber.clear();
    alternateMobileNumber.clear();
    companyName.clear();
    websiteUrl.clear();
    address.clear();
    userAssigned.clear();
    status.clear();
    followUpdate.clear();
    lastUpdate.clear();
    comments.clear();
    industry.clear();
  }
}
