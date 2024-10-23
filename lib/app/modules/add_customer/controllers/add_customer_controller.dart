import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';
import 'package:intl/intl.dart';
import 'package:lms/app/modules/add_customer/extension/addCustomerExtension.dart';
import 'package:lms/app/modules/home/extension/dashboard_extension.dart';
import 'package:lms/app/routes/app_pages.dart';

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
  var selectedServices = 'Website'.obs;
  List<String> services = ['Website', 'Android App', 'AMC'];
  var selectedStatus = "Open".obs;
  var status = <String>[].obs;
  var selectedCity = "Patna".obs;
  List<String> city = ['Patna', 'Samastipur', 'Begusarai'];
  var selectedSources = "JustDial".obs;
  List<String> sources = ['JustDial', 'Google', 'Website'];
  var selectedDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchStatuses();
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

  // Update selected dropdown values
  void updateSelectedItem(String? newValue) {
    if (newValue != null) {
      selectedServices.value = newValue;
    }
  }
  void updateSelectedCity(String? newValue) {
    if (newValue != null) {
      selectedCity.value = newValue;
    }
  }
  void updateSelectedSource(String? newValue) {
    if (newValue != null) {
      selectedSources.value = newValue;
    }
  }
  void updateSelectedStatus(String? newValue) {
    if (newValue != null) {
      selectedStatus.value = newValue;
    }
  }
  Future<void> selectDate(BuildContext context) async {
    // Show the date picker
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );

    if (pickedDate != null) {
      // If a date was selected, show the time picker
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine the picked date and time
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        // Update the selectedDate with the combined date and time
        selectedDate.value = selectedDateTime;
      }
    }
  }

// Formatting the date and time for display, with initial text as "Follow Up Date"
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


  // Save customer data
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
          status: selectedStatus.value,
          followupdate: formattedDate,
          lastupdate: formattedDate,
          comments: '',
          industry: '',
          city: selectedCity.value,
          source: selectedSources.value,
          service: selectedServices.value,
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
    selectedServices.value = 'Website';
    selectedStatus.value = 'Open';
    selectedCity.value = 'Patna';
    selectedSources.value = 'JustDial';
    selectedDate.value = null;
  }

  void updateSelectedService(String newValue) {}
}
