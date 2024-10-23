import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms/app/api/api_controller.dart';
import 'package:lms/app/modules/customerListScreen/extension/customerListExtension.dart';
import 'package:lms/app/modules/home/extension/dashboard_extension.dart';
import 'package:lms/app/modules/loginScreen/controllers/login_screen_controller.dart';
import 'package:lms/app/modules/loginScreen/extension/login_extension.dart';
import '../app/data/constants.dart';
import '../app/modules/customerListScreen/model/customerListModel.dart';
import '../app/modules/customerListScreen/views/customer_list_screen_view.dart';
import '../app/modules/home/model/dashboard_model.dart';
import '../app/modules/loginScreen/model/login_model.dart';
import '../app/routes/app_pages.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final userController =
        Get.put(UserController()); // Create UserController instance
    GetStorage box = GetStorage();
    var lead = userController.dashboardData.value.lead;

    return Drawer(
      shadowColor: Colors.white,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Image(
            image: const AssetImage("assets/images/Lms-preview.png"),
            height: 100.h,
            width: 100.w,
          ).paddingSymmetric(vertical: 50),
          Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${userController.userName.value}',style: TextStyle(color: Colors.black),),
              SizedBox(height: 10.h),
              Text(userController.userType.value),
              SizedBox(height: 10.h),
            ],
          ).paddingOnly(right: 150)),

          SizedBox(height: 15.h),
          const Divider(
            indent: 20,
            color: Colors.black,
            thickness: 2,
          ),
          SizedBox(height: 20.h),
          Obx(() => Column(
                children: userController.statusList
                    .map((status) => Column(
                          children: [
                            CustomRowItem(
                              icon: getStatusIcon(
                                  status), // Get icon based on status
                              text: status,
                              onTap: () async {
                                // Fetch the UID from storage
                                String uid = box.read('userDetail')['uid'];

                                String selectedStatus = status;
                                print("uid value >> ${uid}");
                                print(
                                    "selectedStatus value >> $selectedStatus");

                                box.write('selectedStatus', selectedStatus);
                                List<dynamic> data = await userController
                                    .customerListByStatus(uid, selectedStatus);
                                print(
                                    'Fetched Data for $selectedStatus: $data');

                                Get.to(() => CustomerListScreenView(),
                                    arguments: {
                                      'uid': uid,
                                      'status': selectedStatus,
                                    });
                              },
                            ),
                            SizedBox(height: 20.h), // Add space after each item
                          ],
                        ))
                    .toList(),
              )),
          CustomRowItem(
            icon: Icons.exit_to_app,
            text: "LogOut",
            onTap: () {
              userController.logout();
            },
          ),
        ],
      ),
    );
  }
}

class CustomRowItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final TextStyle? textStyle;
  final double? iconSize;
  final double? spacing;
  final double? horizontalPadding;
  final void Function()? onTap;

  const CustomRowItem({
    Key? key,
    required this.icon,
    required this.text,
    this.textStyle,
    this.iconSize,
    this.spacing,
    this.horizontalPadding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 18.w),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: iconSize ?? 24.sp),
            SizedBox(width: spacing ?? 10.w),
            Text(
              text,
              style: textStyle ??
                  TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserController extends GetxController {
  GetStorage box = GetStorage();
  var userName = ''.obs; // Observable string for username
  var userType = ''.obs; // Observable string for user type

  var dashboardData = DashBoardModel().obs;
  var statusList = <String>[].obs;
  var isLoading = false.obs;
  var customerStatusList = CustomerStatusListModel().obs;
  var userData = LoginApi().obs;

  final ApiController apiController = ApiController(); // Initialize ApiController

  @override
  void onInit() {
    super.onInit();
    fetchStatuses();
    getDataFromStorage();// Fetch status list from the API
  }


  void fetchDashboardData(String uid) async {
    try {
      isLoading.value = true; // Show loading indicator
      DashBoardModel data = await apiController.dashBoardApi(uid);
      dashboardData.value = data;
    } finally {
      isLoading.value = false; // Hide loading indicator
    }
  }

  void logout() {
    box.erase(); // Clear stored data
    Constants.userDetails = ["uid", "userFullName", "userType"];
    Get.offAllNamed(Routes.LOGIN_SCREEN); // Navigate to the login screen
  }
   getDataFromStorage() {
    // Retrieve data from storage
    var storedUserName = box.read(Constants.userDetails[1]);
    var storedUserType = box.read(Constants.userDetails[2]);
    print("USERFULLNAME>>>${Constants.userDetails[1]}");

    // Update the observables
    userName.value = storedUserName ;
    userType.value = storedUserType ;

    // Call the UI method to update the view (this can be a function you define)
    updateUI();
  }

  void updateUI() {
    // Update the UI or perform any other actions needed
    // For example, you can call a function to refresh the screen or navigate
    print('User Name: ${userName.value}');
    print('User Type: ${userType.value}');
    // You can add additional UI update logic here
  }






  Future<List<dynamic>> customerListByStatus(String uid, String status) async {
    try {
      isLoading.value = true;
      CustomerStatusListModel data = await apiController.fetchCustomerStatusListApi(uid, status);
      customerStatusList.value = data;

      switch (status) {
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
  }

  // Function to fetch statuses from the API
  Future<void> fetchStatuses() async {
    try {
      DashBoardModel dashboardData = await apiController.dashBoardApi('status');
      if (dashboardData.success == true) {
        statusList.clear();
        for (Lead lead in dashboardData.lead!) {
          if (lead.status != null) {
            statusList.add(lead.status!);
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
}

IconData getStatusIcon(String status) {
  switch (status.toLowerCase()) {
    case 'disconnected':
      return Icons.hearing_disabled_outlined;
    case 'follow up':
      return Icons.follow_the_signs;
    case 'ringing':
      return Icons.phone_in_talk;
    case 'switch off':
      return Icons.power_off;
    case 'not interested':
      return Icons.not_interested;
    case 'hot lead':
      return Icons.whatshot;
    case 'open':
      return Icons.open_in_browser_sharp;
    case 'office enquiry':
      return Icons.location_searching_sharp;
    case 'to be verified':
      return Icons.verified;
    case 'transfer to senior':
      return Icons.offline_share_outlined;
    default:
      return Icons.circle_outlined; // Default icon for unknown statuses
  }
}
// Define the extension on LoginApi

