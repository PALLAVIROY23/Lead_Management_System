import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../customWidgets/color_extension.dart';
import '../../../routes/app_pages.dart';
import '../../add_customer/controllers/add_customer_controller.dart';
import '../controllers/customer_list_screen_controller.dart';
import 'package:record/record.dart';
import 'package:path/path.dart';

class CustomerListScreenView extends GetView<CustomerListScreenController> {
  CustomerListScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(CustomerListScreenController(apiController: ApiController()));

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.toNamed(Routes.HOME);
              },
              icon: const ImageIcon(
                AssetImage("assets/images/backArrow.png"),
                size: 28,
                color: Colors.white,
              )),
          title: Text(
            "Customer List",
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
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
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  backgroundColor: Colors.white,
                  builder: (BuildContext context) {
                    return CustomerFilterModal();
                  },
                );
              },
              icon: const ImageIcon(
                AssetImage("assets/images/sort.png"),
                color: Colors.white,
                size: 28,
              ),
            ).paddingOnly(right: 10, bottom: 10),
          ],
          backgroundColor: HexColor.fromHex(" #FFFFFF")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_CUSTOMER,
              arguments: controller.selectedStatus.value);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(
          Icons.person_add_alt_1_rounded,
          size: 30,
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Search bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  HexColor.fromHex("#1D4288"),
                  HexColor.fromHex("#6F8FAF"),
                ],
              ),
            ),
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    textAlign: TextAlign.start,
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      hintText: ' Search here ',
                      hintStyle:
                          TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    onChanged: (value) {
                      controller
                          .filterCustomerList(value); // Call the filter method
                    },
                  ),
                ),
              ],
            ),
          ).paddingSymmetric(horizontal: 30.w, vertical: 15.h),
          SizedBox(height: 10.h),

          // List of customers based on the passed status
          Expanded(
            child: Obx(() {
              // Loading indicator
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Check if customerStatusList is null or has empty leads
              if (controller.customerStatusList.value.lead == null ||
                  controller.customerStatusList.value.lead!.isEmpty) {
                return Center(
                  child: Text(
                      'No customer data found for status: ${controller.selectedStatus.value}'),
                );
              }

              // ListView showing customer details
              return ListView.separated(
                itemCount: controller.filteredCustomerList
                    .length, // Use the filtered list length
                itemBuilder: (context, index) {
                  var customer = controller.filteredCustomerList[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          HexColor.fromHex("#1D4288"),
                          HexColor.fromHex("#6F8FAF"),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.0, 0.8],
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        Column(
                          children: [
                            buildCustomerRow("Name", customer?.name),
                            SizedBox(height: 7.h),
                            buildCustomerRow("Mobile", customer?.mobile),
                            SizedBox(height: 7.h),
                            buildCustomerRow("Address", customer?.address),
                            SizedBox(height: 7.h),
                            buildCustomerRow("Company", customer?.companyname),
                            SizedBox(height: 7.h),
                            buildCustomerRow("Status", customer?.status),
                            SizedBox(height: 7.h),
                            buildCustomerRow("Services", customer?.service),
                            SizedBox(height: 7.h),
                            buildCustomerRow(
                                "FollowUpDate", customer?.followupdate),
                            SizedBox(height: 7.h),
                          ],
                        ).paddingSymmetric(
                          horizontal: 21.w,
                        ),
                        // Buttons: Edit, View, Call
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Edit Button
                            myButton(
                              text: "Edit",
                              onTap: () {
                                Get.toNamed(
                                  Routes.UPDATE_CUSTOMER_DETAILS,
                                  arguments: {
                                    'name': customer?.name,
                                    'mobile': customer?.mobile,
                                    'address': customer?.email,
                                    'companyname': customer?.companyname,
                                    'status': customer?.status,
                                    'service': customer?.service,
                                    "alternatemobile":
                                        customer?.alternatemobile,
                                  },
                                );
                              },
                              color: Colors.redAccent,
                              textcolor: Colors.white,
                              icon: Icons.edit,
                              iconColor: Colors.white,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade200,
                                  Colors.red.shade500,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.2, 1],
                              ),
                            ),

                            // View Button
                            myButton(
                              text: "View",
                              onTap: () {
                                if (customer != null) {
                                  Get.toNamed(
                                    Routes.VIEW_SCREEN,
                                    arguments: {
                                      'name': customer.name,
                                      'mobile': customer.mobile,
                                      'address': customer.address,
                                      'companyname': customer.companyname,
                                      'status': customer.status,
                                      'service': customer.service,
                                      'followupdate': customer.followupdate,
                                    },
                                  );
                                } else {
                                  Get.snackbar(
                                      'Error', 'Customer data not available');
                                }
                              },
                              color: Colors.orangeAccent,
                              textcolor: Colors.white,
                              icon: Icons.remove_red_eye_outlined,
                              iconColor: Colors.white,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade200,
                                  Colors.orange.shade500,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.2, 1],
                              ),
                            ),

                            // Call Button
                            myButton(
                              text: "Call",
                              onTap: () async {
                                if (customer?.mobile != null &&
                                    customer!.mobile!.isNotEmpty) {
                                  // Request permissions
                                  var phoneStatus =
                                      await Permission.phone.request();
                                  var audioStatus =
                                      await Permission.microphone.request();

                                  // Check if both permissions are granted
                                  if (phoneStatus.isGranted &&
                                      audioStatus.isGranted) {
                                    final Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: customer.mobile,
                                    );
                                    print("Attempting to launch: $launchUri");

                                    // Attempt to launch the dialer
                                    if (await canLaunchUrl(launchUri)) {
                                      // Start recording before launching the call
                                      await controller.startRecording();

                                      // Delay slightly to ensure recording has started before making the call
                                      await Future.delayed(
                                          Duration(milliseconds: 100));

                                      await launchUrl(launchUri);
                                    } else {
                                      print("Cannot launch URI: $launchUri");
                                      Get.snackbar(
                                          'Error', 'Could not launch dialer');
                                    }
                                  } else {
                                    // Notify the user of permission denial
                                    Get.snackbar('Permission Denied',
                                        'Phone call or microphone permission denied');
                                  }
                                } else {
                                  Get.snackbar(
                                      'Error', 'Mobile number not available');
                                }
                              },
                              color: Colors.blue.shade300,
                              textcolor: Colors.white,
                              icon: Icons.call,
                              iconColor: Colors.white,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade200,
                                  Colors.blue.shade500,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.2, 1],
                              ),
                            )
                          ],
                        ).paddingSymmetric(vertical: 20.h),
                      ],
                    ),
                  ).paddingSymmetric(horizontal: 20.w);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.h);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper method to build customer info row
  Widget buildCustomerRow(String label, String? value) {
    return Row(
      children: [
        Text(
          "$label   :   ", // Label (e.g., "Name:")
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
              color: Colors.white),
        ),
        // Space between label and value
        Expanded(
          child: Text(
            value ?? 'N/A', // Value (or 'N/A' if null)
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
            // Handle overflow if text is too long
          ),
        ),
      ],
    );
  }

  Widget myButton({
    String? text,
    void Function()? onTap,
    Color? color,
    Color? textcolor,
    IconData? icon,
    Color? iconColor,
    Gradient? gradient,
    double? height, // Optional height
    double? width, // Optional width
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 40.h, // Use default if null
        width: width ?? 90.w, // Use default if null
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color, // This will be used only if gradient is null
          gradient: gradient, // Apply gradient if provided
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: iconColor ?? textcolor, // Use iconColor if provided
                size: 16,
              ),
            if (icon != null && text != null) SizedBox(width: 5.w),
            if (text != null)
              Text(
                text,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textcolor),
              ),
          ],
        ),
      ),
    );
  }

  Widget CustomerFilterModal() {
    final AddCustomerController controller = Get.put(AddCustomerController(apiController: ApiController()));
    return Container(
      height: 90.sh,
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Dropdown
            Obx(() => _buildDropdown(
              value: controller.selectedServices.value.isNotEmpty
                  ? controller.selectedServices.value
                  : null,
              onChanged: (newValue) {
                if (newValue != null) {
                  controller.updateSelectedService(newValue);
                }
              },
              items: controller.services.toSet(),
            )),
            SizedBox(height: 20.h),

            // Other Dropdowns (add more as needed)
            // Repeating dropdown example
            Obx(() => _buildDropdown(
              value: controller.selectedServices.value.isNotEmpty
                  ? controller.selectedServices.value
                  : null,
              onChanged: (newValue) {
                if (newValue != null) {
                  controller.updateSelectedService(newValue);
                }
              },
              items: controller.services.toSet(),
            )),
            SizedBox(height: 30.h),

            // Action Buttons
            Row(
              children: [
                myButton(
                  onTap: () {
                    print("Filter Customer");
                  },
                  height: 80.h,
                  width: 140.h,
                  text: "Filter Customer",
                  color: HexColor.fromHex("#1D4288"),
                  textcolor: Colors.white,
                ),
                SizedBox(width: 75.w),
                myButton(
                  onTap: () {
                    print("Add Customer");
                  },
                  height: 80.h,
                  width: 140.w,
                  text: "Add Customer",
                  color: HexColor.fromHex("#ed2d2c"),
                  textcolor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    String? value,
    required ValueChanged<String?>? onChanged,
    required Set<String> items,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_sharp),
          onChanged: onChanged,
          underline: Container(),
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }


}


