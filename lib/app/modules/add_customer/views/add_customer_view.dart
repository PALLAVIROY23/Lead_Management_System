import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../customWidgets/CustomTextField.dart';
import '../../../../customWidgets/color_extension.dart';
import '../controllers/add_customer_controller.dart';

class AddCustomerView extends GetView<AddCustomerController> {
  const AddCustomerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: ImageIcon(
              AssetImage("assets/images/backArrow.png"),
              size: 28,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Add Customer",
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
          backgroundColor: HexColor.fromHex("#FFFFFF"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Customer Name Text Field
              CustomTextField(
                controller: controller.customerNameController,
                // Bind to controller
                HintText: "Enter Customer Name",
                Radius: 25,
                width: 380.w,
                keyboardType: TextInputType.name,
                obscureText: false,
                isOutlineInputBorder: false,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                outlineborder: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              SizedBox(height: 10.h),

              // Email Text Field
              CustomTextField(
                controller: controller.emailController,
                // Bind to controller
                HintText: "Enter mail I'd",
                Radius: 15,
                width: 380.w,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                isOutlineInputBorder: false,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                outlineborder: OutlineInputBorder(borderSide: BorderSide.none),
              ),
              SizedBox(height: 10.h),

              // Mobile Number Text Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: controller.mobileNumber,
                  // Bind to controller
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    hintText: "Mobile Number",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[6-9]\d{0,9}$')),
                  ],
                  validator: (value) {
                    if (value == null || value.length != 10) {
                      return 'Please Enter a valid Phone Number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 10.h),

              // Alternate Mobile Number Text Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: controller.alternateMobileNumber,
                  // Bind to controller
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    hintText: "Alternate Mobile Number",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[6-9]\d{0,9}$')),
                  ],
                  validator: (value) {
                    if (value == null || value.length != 10) {
                      return 'Please Enter a valid Phone Number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 10.h),

              // Company Name Text Field
              CustomTextField(
                controller: controller.companyNameController,
                // Bind to controller
                HintText: "Company Name",
                Radius: 15,
                width: 380.w,
                keyboardType: TextInputType.text,
                obscureText: false,
                isOutlineInputBorder: false,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                outlineborder: const OutlineInputBorder(
                    borderSide: BorderSide.none),
              ),
              SizedBox(height: 10.h),

              // Services Dropdown
              Obx(() =>
                  Container(
                    width: 380.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<String>(
                        value: controller.selectedServices.value,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        onChanged: controller.updateSelectedItem,
                        underline: Container(),
                        // Removing the underline
                        items: controller.services.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )),
              SizedBox(height: 10.h),

              // City Dropdown
              Obx(() =>
                  Container(
                    width: 380.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<String>(
                        value: controller.selectedCity.value,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        onChanged: controller.updateSelectedCity,
                        underline: Container(),
                        // Removing the underline
                        items: controller.city.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )),
              SizedBox(height: 10.h),

              // Follow-up Date
              Obx(() => GestureDetector(
                onTap: () => controller.selectDate(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 16.0.h, horizontal: 12.0.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade200,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.formattedDate,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: controller.formattedDate == 'Follow Up Date'
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )),

              SizedBox(height: 10.h),

              // Source Dropdown
              Obx(() =>
                  Container(
                    width: 380.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton<String>(
                        value: controller.selectedSources.value,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        onChanged: controller.updateSelectedSource,
                        underline: Container(),
                        // Removing the underline
                        items: controller.sources.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )),
              SizedBox(height: 10.h),

              // Status Dropdown
              Obx(() =>
                  Container(
                    width: 380.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButton<String>(
                        value: controller.selectedStatus.value,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        onChanged: controller.updateSelectedStatus,
                        underline: Container(),
                        // Removing the underline
                        items: controller.status.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )),
              SizedBox(height: 20.h),

              // Add Customer Button
              updateButton(
                text: "Add Customer",
                onTap: controller.saveCustomer,

                // Trigger controller's addCustomer
                Color: HexColor.fromHex("#1E355F"),
                textcolor: Colors.white,
              ),
            ],
          ).paddingSymmetric(vertical: 20.h,horizontal: 20.w),
        )
    );
  }
}


Widget updateButton(
    {String? text, void Function()? onTap, Color? Color, Color? textcolor}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 60.h,
      width: 300.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          text == null
              ? SizedBox()
              : Text(
            text,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: textcolor),
          ),
        ],
      ),
    ),
  );
}