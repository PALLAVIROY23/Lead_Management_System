
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms/app/modules/customerListScreen/extension/customerListExtension.dart';
import 'package:lms/app/modules/home/extension/dashboard_extension.dart';
import 'package:intl/intl.dart';
import 'package:lms/app/modules/viewScreen/extension/updateExtension.dart';
import 'package:lms/app/routes/app_pages.dart';

import '../../../api/api_controller.dart';
import '../../customerListScreen/model/customerListModel.dart';
import '../../customerListScreen/views/customer_list_screen_view.dart';
import '../../home/model/dashboard_model.dart';

class ViewScreenController extends GetxController {
  GetStorage box = GetStorage();
  ApiController apiController;

  ViewScreenController({required this.apiController});
  var selectedStatus = Rx<String?>(null); // Selected status for dropdown
  var status = <String>[].obs; // Observable list to hold statuses from API
  var args = Get.arguments;
  var comment = ''.obs; // Observable for comment input
  var isLoading = true.obs;
  var customerUpdatedStatusList = CustomerStatusListModel().obs;
  var dashboardData = DashBoardModel().obs;
  var leads = <Lead>[].obs;
  var selectedDate = Rx<DateTime?>(null);
  var customerData = <LeadData>[].obs;
  var selectedStatusList = <dynamic>[].obs;
  var userId = " ".obs;
  var leadDetails = {}.obs;

  @override
   onInit() {
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
        EasyLoading.showSuccess('Statuses loaded successfully');
      } else {
        EasyLoading.showError(dashboardData.msg ?? 'Failed to load statuses');
      }
    } catch (e) {
      EasyLoading.showError('An error occurred while fetching statuses');
      log('Error: $e');
    }
  }

  void updateSelectedStatus(String value) {
    selectedStatus.value = value;
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

  void updateSelectStatus(String value) {
    selectedStatus.value = value;
  }
/*  void onSubmitDetails() async {
    try {
      // Retrieve the current selected status
      String? currentStatus = selectedStatus.value;
      if (currentStatus == null || currentStatus.isEmpty) {
        EasyLoading.showError("Please select a status first");
        return;
      }

      // Extract data from the arguments
      String? leadId = args["id"];
      String? followUpDate = args["followupdate"];
      String? lastUpdate = args["lastupdate"];
      String? oldComments = args["comments"];
      String? newComments = comment.value; // Get the updated comment from the controller

      if (leadId == null) {
        EasyLoading.showError("Lead ID is missing");
        return;
      }

      // Show loading indicator
      EasyLoading.show(status: "Updating...");

      // Call the updateDetails API to update the status and other details
      final response = await apiController.updateDetails(
        id: leadId,
        status: currentStatus,
        followupdate: followUpDate,
        lastupdate: lastUpdate,
        oldcomments: oldComments,
        comments: newComments,
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Update the local customerData list
        int existingIndex = customerData.indexWhere((lead) => lead.id == leadId);
        if (existingIndex != -1) {
          // Update the existing data
          customerData[existingIndex] = LeadData(
            id: leadId,
            name: args["name"],
            mobile: args["mobile"],
            city: args["address"],
            status: currentStatus,
            service: args["service"],
            source: args["source"],
            companyname: args["companyname"],
            lastupdate: lastUpdate,
            followupdate: followUpDate,
            comments: newComments,
          );
        }

        // Update the selectedStatusList based on the new status
        selectedStatusList.clear();
        selectedStatusList.addAll(
          customerData.where((lead) => lead.status == currentStatus),
        );

        // Show a success message
        EasyLoading.showSuccess("Data has been moved to $currentStatus status");
        Get.toNamed(Routes.HOME);
      } else {
        // Show error if the API response is not successful
        EasyLoading.showError("Failed to update details: ${response.statusMessage}");
      }
    } catch (e) {
      print("Error while updating details: $e");
      EasyLoading.showError("Error updating details: $e");
    }
  }*/



  Future<void> onSubmitDetails() async {
    String uid = box.read('userDetail')['uid'];
    try {
      // Retrieve the current selected status
      String? currentStatus = selectedStatus.value;

      if (currentStatus == null || currentStatus.isEmpty) {
        EasyLoading.showError("Please select a status first");
        return;
      }

      // Extract data from the arguments and create a new LeadData object
      LeadData newLeadData = LeadData(
        name: args["name"],
        mobile: args["mobile"],
        city: args["address"],
        status: currentStatus, // Assign the selected status
        service: args["service"],
        source: args["source"],
        companyname: args["companyname"],
        lastupdate: args["lastupdate"],
        followupdate: args["followupdate"],
        comments: args["12"],
        id: args["id"],
      );

      // Check if the new lead is already in the customerData list based on the ID
      bool isExisting = customerData.any((lead) => lead.id == newLeadData.id);

      if (isExisting) {
        // Update the existing lead data in the list
        int index = customerData.indexWhere((lead) => lead.id == newLeadData.id);
        customerData[index] = newLeadData;
      } else {
        // Add the new LeadData to the customerData list
        customerData.add(newLeadData);
      }

      // Update the selectedStatusList with only the data that matches the provided ID and current status
      selectedStatusList.clear();
      selectedStatusList.addAll(
        customerData.where((lead) => lead.id == newLeadData.id && lead.status == currentStatus),
      );

      // Show a success message
      EasyLoading.showSuccess("Data has been moved to $currentStatus status");
      Get.toNamed(Routes.CUSTOMER_LIST_SCREEN);
   /*   print('Fetched Data for $selectedStatus: $uid');
      Get.to(() => CustomerListScreenView(), arguments: {
        'uid': uid,
        'status': currentStatus,
      });*/



    } catch (e) {
      print("Error while moving data to selected status: $e");
      EasyLoading.showError("Error moving data: $e");
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


}
