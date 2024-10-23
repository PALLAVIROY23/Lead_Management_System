import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms/app/modules/customerListScreen/extension/customerListExtension.dart';
import 'package:lms/app/modules/home/extension/dashboard_extension.dart';
import 'package:intl/intl.dart';

import '../../../api/api_controller.dart';
import '../../customerListScreen/model/customerListModel.dart';
import '../../customerListScreen/views/customer_list_screen_view.dart';
import '../../home/model/dashboard_model.dart';

class ViewScreenController extends GetxController {
  GetStorage box = GetStorage();
  ApiController apiController;

  ViewScreenController({required this.apiController});
  var selectedStatus = "Open".obs; // Selected status for dropdown
  var status = <String>[].obs; // Observable list to hold statuses from API
  var args = Get.arguments;
  var comment = ''.obs; // Observable for comment input
  var isLoading = true.obs;
  var customerUpdatedStatusList = CustomerStatusListModel().obs;
  var dashboardData = DashBoardModel().obs;
  var leads = <Lead>[].obs; // Observable list to store the fetched leads
  var selectedDate = Rx<DateTime?>(null);




  @override
  void onInit() {
    super.onInit();
    fetchStatuses();
  }

  Future<void> fetchStatuses() async {
    try {
      DashBoardModel dashboardData = await apiController.dashBoardApi(args['status']);
      if (dashboardData.success == true) {
        status.clear();
        leads.clear(); // Clear the previous list of leads
        for (Lead lead in dashboardData.lead!) {
          if (lead.status != null) {
            status.add(lead.status!);
          }
          leads.add(lead); // Add the lead to the observable list
        }
        // Show success message if needed
        EasyLoading.showSuccess('Statuses loaded successfully');
      } else {
        EasyLoading.showError(dashboardData.msg ?? 'Failed to load statuses');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred while fetching statuses');
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

        selectedDate.value = selectedDateTime;
      }
    }
  }

  String get formattedDate => selectedDate.value != null
      ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDate.value!)
      : 'Follow Up Date';

  void updateSelectedStatus(String value) {
    selectedStatus.value = value;
  }

  // New method to validate inputs
   validateInputs() {
    if (comment.value.isEmpty || selectedStatus.value.isEmpty || selectedDate.value == null) {
      EasyLoading.showError("Please fill all details"); // Show error message
      return;
    }
    navigateToCustomerDetails();
  }

  Future<dynamic> navigateToCustomerDetails() async {
    try {
      isLoading.value = true;

      // Retrieve UID and status from local storage
      String uid = box.read('userDetail')['uid'];
      String status = selectedStatus.value;
      String commentValue = comment.value;
      String selectedDateValue = selectedDate.value?.toString() ?? '';

      // Log the parameters being sent to the API
      print("Fetching customer status list with UID: $uid, Status: $status");

      // Fetch the customer status list data using the API
      CustomerStatusListModel data = await apiController.fetchCustomerStatusListApi(uid, status);

      if (!(data.success ?? false)) {
        print("API call failed: ${data.msg ?? 'No message provided'}");
        EasyLoading.showError("Failed to fetch customer status list. ${data.msg ?? ''}");
        return [];
      }

      // Update the customer status list with the fetched data
      customerUpdatedStatusList.value = data;

      // Get the leads for the selected status
      List<LeadData> newLeads = data.lead?.where((lead) => lead.status == status).toList() ?? [];

      // Log the number of new leads found
      print("Number of leads found for status $status: ${newLeads.length}");

      // If no leads are found, show a message and prevent navigation
      if (newLeads.isEmpty) {
        EasyLoading.showInfo("No leads found for the selected status.");
        print("Lead data is null or empty");
        return [];
      }

      // Update the leads list: first remove the current leads for the selected status, then add the new leads
      leads.removeWhere((lead) => lead.status == status);
      leads.addAll(newLeads.map((leadData) => Lead(
        status: leadData.status,
        // Include any additional fields here
      )));

      // Store the selected status and additional details in local storage
      box.write('selectedStatus', status);
      box.write('comment', commentValue);
      box.write('selectedDate', selectedDateValue);

      // Fetch customer list based on the selected status
      List<dynamic> fetchedData = await customerListByStatus(uid, status);
      print('Fetched Data for $status: $fetchedData');

      // If fetchedData is empty or indicates failure, handle the situation
      if (fetchedData.isEmpty || fetchedData.toString().contains('No Data Available')) {
        print("No data available for $status");
        EasyLoading.showInfo("No data available for $status");
        return [];
      }

      // Navigate to the CustomerListScreenView with arguments
      Get.to(() => CustomerListScreenView(), arguments: {
        'uid': uid,
        'status': status,
        'comment': commentValue,
        'selectedDate': selectedDateValue,
      });

    } catch (e) {
      print("Error occurred while fetching status data: $e");
      EasyLoading.showError("Error fetching data: $e");
      return ['Error fetching data'];
    } finally {
      isLoading.value = false;
    }
  }





  customerListByStatus(String uid, String status) async {
    try {
      isLoading.value = true;

      // Call the common API with the UID and varying status
      CustomerStatusListModel data = await apiController.fetchCustomerStatusListApi(uid, status);

      // Set the customer status list with the fetched data
      customerUpdatedStatusList.value = data;

      // Process the data according to the status
      switch (status) {
        case 'Disconnected':
          return data.lead?.map((lead) => lead.status).toList() ?? [];
        case 'Follow Up':
          return data.lead?.map((lead) => lead.status).toList() ?? [];
        case 'Hot Lead':
          return data.lead?.map((lead) => lead.status).toList() ?? [];
        case 'Not Interested':
          return data.lead?.map((lead) => lead.status).toList() ?? [];
        case 'Office Enquiry':
          return data.lead?.map((lead) => lead.status).toList() ?? [];
        case 'Open':
          return data.lead?.map((lead) => lead.status).toList() ?? [];
        case 'Ringing':
          return data.lead?.map((lead) => lead.status).toList() ?? [];
        case 'Switch Off':
          return data.lead?.map((lead) => lead.status).toList() ?? [];
        case 'To be Verified':
          return data.lead?.map((lead) => lead.status).toList() ?? [];
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
  }

  void removeLeadFromCurrentStatus(String leadId) {
    try {
      // Find the index of the lead with the given leadId
      int index = leads.indexWhere((lead) => lead.status == leadId);

      if (index != -1) {
        // If the lead is found, remove it from the list
        leads.removeAt(index);
        EasyLoading.showSuccess('Lead removed successfully');
      } else {
        // If the lead is not found, show an error message
        EasyLoading.showError('Lead not found');
      }
    } catch (e) {
      // Handle any errors that occur during the removal process
      print('Error occurred while removing lead: $e');
      EasyLoading.showError('An error occurred while removing the lead');
    }
  }




}
