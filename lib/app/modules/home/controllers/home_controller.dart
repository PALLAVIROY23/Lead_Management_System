import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';
import 'package:lms/app/modules/customerListScreen/extension/customerListExtension.dart';
import 'package:lms/app/modules/home/extension/dashboard_extension.dart';

import '../../customerListScreen/model/customerListModel.dart';
import '../model/dashboard_model.dart';

class HomeController extends GetxController {
  ApiController apiController;

  HomeController({required this.apiController});


  var selectedIndex = 0.obs;
  var dashboardData = DashBoardModel().obs;
  var customerStatusList = CustomerStatusListModel().obs;
  var isLoading = true.obs;
  final count = 0.obs;



  // Method to update the selected index
  onItemTapped(int index) {
    selectedIndex.value = index;
  }

  void increment() => count.value++;

  @override
  void onInit() {
    super.onInit();

    String uid = "uid";
    fetchDashboardData(uid);
  }

  // Fetch data from the API
  // Method to fetch dashboard data with uid as a parameter
  Future<void> fetchDashboardData(String uid) async {
    try {
      isLoading.value = true; // Show loading indicator

      // Fetch the data from the API using the provided uid
      DashBoardModel data = await apiController.dashBoardApi(uid);
      dashboardData.value = data; // Update the dashboard data
    } catch (e) {
      // Optionally handle errors here
      EasyLoading.showError("Failed to load data");
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

// Refresh method for RefreshIndicator with uid as a parameter
  Future<void> refreshDashboardData(String uid) async {
    await fetchDashboardData(uid); // Re-fetch the data using the provided uid
  }


  customerListByStatus(String uid, String status) async {
    try {
      isLoading.value = true;

      // Call the common API with the UID and varying status
      CustomerStatusListModel data = await apiController.fetchCustomerStatusListApi(uid, status);

      // Set the customer status list with the fetched data
      customerStatusList.value = data;

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




  final List<Color> boxColors = [
    Colors.blue,
    Colors.red,
    Colors.blueGrey,
    Colors.grey,
    Colors.pinkAccent,
    CupertinoColors.systemPurple,
    Colors.brown,
    Colors.lightBlueAccent,
  ];




}
