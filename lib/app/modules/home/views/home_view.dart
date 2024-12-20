import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../customWidgets/color_extension.dart';
import '../../../../customWidgets/drawer.dart';
import '../../customerListScreen/views/customer_list_screen_view.dart';
import '../controllers/home_controller.dart';
import '../model/dashboard_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lead Management System",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 80.h,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: HexColor.fromHex("#1D4288"),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
              size: 35,
            ),
          ).paddingOnly(right: 10, bottom: 10),
        ],
        backgroundColor: HexColor.fromHex("#FFFFFF"),
      ),
      backgroundColor: HexColor.fromHex("#FFFFFF"),
      drawer: NavBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            String uid = "uid"; // Replace with actual UID retrieval
            await controller.refreshDashboardData(uid);
          },
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final dashboardData = controller.dashboardData.value;

            return Column(
              children: [
                // Display the main body first
                Expanded(child: remainBody(dashboardData)),
                // Add your banner below the main body
               Column(
                 children: [
                   Image(image: AssetImage("assets/images/banner_LMS.png")).paddingSymmetric(vertical: 30, horizontal: 30)
                 ],
               )
              ],
            );
          }),
        ),
      ),
    );

  }
}

Widget remainBody(DashBoardModel? dashboardData) {
  final HomeController controller = Get.find<HomeController>();
  GetStorage box = GetStorage();

  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 130,
      mainAxisExtent: 80,
      crossAxisSpacing: 0,
      mainAxisSpacing: 12,
    ),
    itemCount: dashboardData?.lead?.length ?? 0,
    itemBuilder: (BuildContext ctx, index) {
      var lead = dashboardData?.lead?[index];
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
        child: InkWell(
          onTap: () async {
            String? selectedStatus = lead?.status;
            String uid = box.read('userDetail')['uid'];
            print(" uid value >>${uid}");
            print(" selectedStatus value >>${selectedStatus}");
            box.write('selectedStatus', lead?.status);
            List<dynamic> data = await controller.customerListByStatus(
                uid, selectedStatus ?? " ");
            print('Fetched Data for $selectedStatus: $data');
            Get.to(() => CustomerListScreenView());
          },
          child: Container(
            decoration: BoxDecoration(
              color: controller.boxColors[index % controller.boxColors.length],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    lead?.count ?? '0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    lead?.status ?? 'Unknown',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ).paddingSymmetric(horizontal: 10.w, vertical: 20.h);
}

class CustomIconTextButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Color textColor; // New text color parameter
  final VoidCallback onPressed;

  const CustomIconTextButton({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: iconColor),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
              color: textColor, fontSize: 12.sp), // Responsive text size
        ),
      ],
    );
  }
}
