import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';
import 'package:lms/app/modules/update_Customer_Details/extension/update_customer_extension.dart';

class UpdateCustomerDetailsController extends GetxController {
  final ApiController apiController;

  UpdateCustomerDetailsController({required this.apiController});

  var selectedServices = 'Website'.obs;
  List<String> items = ['Website', 'Android App', 'AMC'];

  var selectedCity = "Patna".obs;
  List<String> city = ['Patna', 'Samastipur', 'Begusarai'];

  var selectedSources = "JustDial".obs;
  List<String> sources = ['JustDial', 'Google', 'website'];

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

   updateSelectedItem(String? newValue) {
    if (newValue != null) {
      selectedServices.value = newValue;
    }
  }

   updateSelectedCity(String? newValue) {
    if (newValue != null) {
      selectedCity.value = newValue;
    }
  }

   updateSelectedSource(String? newValue) {
    if (newValue != null) {
      selectedSources.value = newValue;
    }
  }

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
          status: selectedServices.value,
          followupdate: followUpdate.text,
          lastupdate: lastUpdate.text,
          comments: comments.text,
          industry: industry.text,
          city: selectedCity.value,
          source: selectedSources.value,
          service: selectedServices.value,
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
