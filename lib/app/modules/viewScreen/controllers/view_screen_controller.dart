import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lms/app/modules/customerListScreen/extension/customerListExtension.dart';
import 'package:lms/app/modules/home/extension/dashboard_extension.dart';
import 'package:intl/intl.dart';

import '../../../api/api_controller.dart';
import '../../customerListScreen/model/customerListModel.dart';
import '../../home/model/dashboard_model.dart';

class ViewScreenController extends GetxController {

  ApiController apiController;


ViewScreenController({required this.apiController});
  var selectedStatus = "Open".obs; // Selected status for dropdown
  var status = <String>[].obs; // Observable list to hold statuses from API
  var args = Get.arguments;
  var comment = ''.obs; // Observable for comment input
  var isLoading = true.obs;

  var customerupdatedStatusList = CustomerStatusListModel().obs;
  var selectedDate = Rx<DateTime?>(null);
  @override
  void onInit() {
    super.onInit();
    fetchStatuses();
    navigateToCustomerDetails(); // Fetch statuses when the controller is initialized
  }

  Future<void> fetchStatuses() async {
    try {
      DashBoardModel dashboardData = await apiController.dashBoardApi(args['status']);
      if (dashboardData.success == true) {
        status.clear();
        for (Lead lead in dashboardData.lead!) {
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

  void updateSelectedStatus(String value) {
    selectedStatus.value = value;
  }




  void validateInputs() {
    if (comment.value.isEmpty || selectedStatus.value.isEmpty || selectedDate.value == null) {
      EasyLoading.showError("Please fill all details"); // Show error message
      return;
    }

    navigateToCustomerDetails();
  }

  Future<dynamic> navigateToCustomerDetails() async {
    try {
      isLoading.value = true;

      String uid = args["uid"] ?? ''; // Default to an empty string if null
      String selected = selectedStatus.value.isNotEmpty ? selectedStatus.value : 'DefaultStatus'; // Fallback to a default status

      CustomerStatusListModel data = await apiController
          .fetchCustomerStatusListApi(uid, selected);

      customerupdatedStatusList.value = data;

      if (data.lead == null || data.lead!.isEmpty) {
        return ['No Data Available'];
      }

      return data.lead?.map((lead) => lead.status).toList() ?? [];
    } catch (e) {
      print("Error occurred while fetching status data: $e");
      print("Full response: ${status}");
      return ['Error fetching data'];
    }
    finally {
      isLoading.value = false;
    }
  }

  // New method to validate inputs
/*  void validateInputs() {
    if (comment.value.isEmpty || selectedStatus.value.isEmpty || selectedDate.value == null) {
      EasyLoading.showError("Please fill all details"); // Show error message
      return;
    }

    // Navigate to customer details according to status
    navigateToCustomerDetails();
  }

  Future<dynamic> navigateToCustomerDetails() async {
    try {
      isLoading.value = true;

      // Call the common API with the UID and varying status
      CustomerStatusListModel data = await apiController
          .fetchCustomerStatusListApi("uid", "status");

      // Set the customer status list with the fetched data
      customerupdatedStatusList.value = data;

      args.remove('status');

      // Navigate based on the selected status
      switch (selectedStatus.value) { // Corrected from `status` to `selectedStatus.value`
        case 'Disconnected':
        case 'Follow Up':
        case 'Hot Lead':
        case 'Not Interested':
        case 'Office Enquiry':
        case 'Open':
        case 'Ringing':
        case 'Switch Off':
        case 'To be Verified':
        case 'Transfer to Senior':
          return data.lead?.map((lead) => lead.status).toList() ?? [];
        default:
          return ['No Data Available'];
      }
    } catch (e) {
      print("Error occurred while fetching status data: $e");
      return ['Error fetching data'];
    } finally {
      isLoading.value = false;
    }
  }*/
}
