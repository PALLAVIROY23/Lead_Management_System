import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lms/app/api/api_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../customWidgets/color_extension.dart';
import '../../../routes/app_pages.dart';
import '../../add_customer/controllers/add_customer_controller.dart';
import '../controllers/customer_list_screen_controller.dart';
import '../model/citiesModel.dart';
import '../model/serviceModel.dart';
import '../model/sourceModel.dart';

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
                Get.back();
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
              onPressed: () async {
                print("Icon button pressed");

                // Show CircularProgressIndicator
                EasyLoading.show(
                    status: 'Loading...'); // Using FlutterEasyLoading

                // Simulate data fetching or any async operation
                await Future.delayed(Duration(
                    seconds: 1)); // Replace with your actual async operation

                // Dismiss the CircularProgressIndicator
                EasyLoading.dismiss();

                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    print("Building modal bottom sheet");
                    return DraggableScrollableSheet(
                      expand: false,
                      builder: (context, scrollController) {
                        return CustomerFilterModal(
                            scrollController: scrollController);
                      },
                    );
                  },
                ).then((_) {
                  print("Modal bottom sheet closed");
                });
              },
              icon: const ImageIcon(
                AssetImage("assets/images/sort.png"),
                color: Colors.white,
                size: 28,
              ),
            ).paddingOnly(right: 10, bottom: 10)
          ],
          backgroundColor: HexColor.fromHex(" #FFFFFF")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.ADD_CUSTOMER,
              arguments: controller.selectStatus.value);
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
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white, fontSize: 18.sp), // Set the text color to white
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      hintText: ' Search here ',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    onChanged: (value) {
                      controller.filterCustomerList(value); // Call the filter method
                    },
                  ),
                ),
              ],
            )

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
                      'No customer data found for status: ${controller.selectStatus.value}'),
                );
              }

              // ListView showing customer details
              return ListView.separated(
                itemCount: controller.filteredCustomerList
                    .length, // Use the filtered list length
                itemBuilder: (context, index) {
                  var customer = controller.filteredCustomerList[index];
                  print("LEADID>>>>>>>>>>>>${customer.id}");
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
                            buildCustomerRow("Name", customer.name),
                            SizedBox(height: 7.h),
                            buildCustomerRow("Mobile", customer.mobile),
                            SizedBox(height: 7.h),
                            buildCustomerRow("Address", customer.address),
                            SizedBox(height: 7.h),
                            buildCustomerRow("Company", customer.companyname),
                            SizedBox(height: 7.h),
                            buildCustomerRow(
                                "Status",
                                customer
                                    .status), // Directly call customer.status
                            SizedBox(height: 7.h),
                            buildCustomerRow("Services", customer.service),
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
                                    /*'id': customer.id*/
                                    'name': customer.name,
                                    'mobile': customer.mobile,
                                    'address': customer.email,
                                    'companyname': customer.companyname,
                                    'status': customer.status,
                                    'service': customer.service,
                                    "alternatemobile": customer.alternatemobile,
                                    "comments": customer.comments,
                                    "Lead Id": customer.id
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
                                    "lastupdate": customer.lastupdate,
                                    "comments": customer.comments,
                                    "Lead Id": customer.id,
                                  },
                                );
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
                                if (customer.mobile != null &&
                                    customer.mobile!.isNotEmpty) {
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
                                        'Phone call or microphone permission denied',
                                        colorText: Colors.red,
                                        backgroundColor: Colors.white);
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

  Widget CustomerFilterModal({required ScrollController scrollController}) {
    final CustomerListScreenController controller = Get.put(
      CustomerListScreenController(apiController: ApiController()),
    );

    return Container(
      height: 90.sh,
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        controller: scrollController, // Pass the scroll controller here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Dropdown
            Obx(() => Container(
                  width: 352.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButton<CustomerService>(
                      value: controller.selectedService.value,
                      isExpanded: true,
                      hint: const Text("Customer Services"),
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      onChanged: (CustomerService? newValue) {
                        if (newValue != null) {
                          controller.updateSelectedService(newValue);
                        }
                      },
                      underline: Container(),
                      items: controller.serviceList
                          .map<DropdownMenuItem<CustomerService>>(
                              (CustomerService service) {
                        return DropdownMenuItem<CustomerService>(
                          value: service,
                          child: Text(service.name ?? 'Unnamed Service'),
                        );
                      }).toList(),
                    ),
                  ),
                )),
            SizedBox(height: 20.h),
            Obx(() => Container(
                  width: 352.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButton<String>(
                      value: controller.selectStatus.value,
                      isExpanded: true,
                      hint: const Text(
                          "Customer Status "), // Display hint when no value is selected
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.updateSelectedStatus(newValue);
                        }
                      },
                      underline: Container(), // Removing the underline
                      items: controller.status
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                )),
            SizedBox(
              height: 20.h,
            ), // Repeating dropdown example
            Obx(() => Container(
                  width: 352.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButton<CitiesData>(
                      value: controller.selectedCity
                          .value, // Use selectedCity from the controller
                      isExpanded: true,
                      hint: const Text(
                          "Select city "), // Display hint when no value is selected
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      onChanged: (CitiesData? newValue) {
                        if (newValue != null) {
                          controller.updateSelectedCity(newValue);
                        }
                      },
                      underline: Container(), // Removing the underline
                      items: controller.city
                          .map<DropdownMenuItem<CitiesData>>((CitiesData city) {
                        return DropdownMenuItem<CitiesData>(
                          value: city, // Set the correct value
                          child: Text(city.name ??
                              ''), // Display the city name, handle null safety
                        );
                      }).toList(),
                    ),
                  ),
                )),

            SizedBox(height: 20.h),
            Obx(() => Container(
                  width: 352.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DropdownButton<SourceList>(
                      value: controller.selectedSource.value,
                      isExpanded: true,
                      hint: const Text(
                          "Customer Source"), // Display hint when no value is selected
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      onChanged: (SourceList? newValue) {
                        if (newValue != null) {
                          controller.updateSelectedSource(newValue);
                        }
                      },
                      underline: Container(), // Removing the underline
                      items: controller.sources
                          .map<DropdownMenuItem<SourceList>>(
                              (SourceList source) {
                        return DropdownMenuItem<SourceList>(
                          value: source,
                          child: Text(source.sourcename ?? "Unknown"),
                        );
                      }).toList(),
                    ),
                  ),
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
    ).paddingSymmetric(
      vertical: 20.h,
    );
  }

  Widget _buildDropdown({
    String? value,
    required ValueChanged<String?>? onChanged,
    required Set<String> items,
    String hintText = "Customer Service", // Add a default hint text
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
          hint: Text(
            hintText,
            style: TextStyle(
                color: Colors.grey), // Optional: Customize hint text style
          ),
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
