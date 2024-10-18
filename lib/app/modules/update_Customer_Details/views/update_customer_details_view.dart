import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../customWidgets/CustomTextField.dart';
import '../../../../customWidgets/color_extension.dart';
import '../controllers/update_customer_details_controller.dart';

class UpdateCustomerDetailsView extends GetView<UpdateCustomerDetailsController> {
  const UpdateCustomerDetailsView({Key? key}) : super(key: key);

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
          "Customer Details",
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            CustomTextField(
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
              controller: controller.customerName, // Added controller
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              HintText: "Enter mail ID",
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
              controller: controller.emailController, // Added controller
            ),
            SizedBox(height: 20.h),
            _buildMobileNumberField(controller.mobileNumber),
            SizedBox(height: 20.h),
            _buildMobileNumberField(
                controller.alternateMobileNumber, "Alternate Mobile Number"),
            SizedBox(height: 20.h),
            CustomTextField(
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
              outlineborder: OutlineInputBorder(borderSide: BorderSide.none),
              controller: controller.companyName, // Added controller
            ),
            SizedBox(height: 20.h),
            _buildDropdown(
              value: controller.selectedServices,
              // Pass the observable RxString
              items: controller.items,
              onChanged: controller.updateSelectedItem,
            ),
            SizedBox(height: 20.h),
            _buildDropdown(
              value: controller.selectedCity, // Pass the observable RxString
              items: controller.city,
              onChanged: controller.updateSelectedCity,
            ),
            SizedBox(height: 20.h),
            _buildDropdown(
              value: controller.selectedSources, // Pass the observable RxString
              items: controller.sources,
              onChanged: controller.updateSelectedSource,
            ),

            SizedBox(height: 50.h),
            updateButton(
              text: "Update Details",
              onTap: () {
                // Check if the inputs are valid before proceeding to update customer details
                if (controller.validateInputs()) {
                  // If all validations pass, call the method to update customer details
                  controller.updateCustomerDetails();
                } else {
                  // Show an error using EasyLoading (already done in validateInputs)
                  EasyLoading.showError("Please fill all required fields");
                }
              },
              Color: HexColor.fromHex("#1E355F"),
              textcolor: Colors.blueAccent,
            ),

          ],
        ).paddingSymmetric(horizontal: 17),
      ),
    );
  }

  Widget _buildMobileNumberField(TextEditingController controller,
      [String hintText = "Mobile Number"]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          hintText: hintText,
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
            RegExp(r'^[+]*[(]{0,1}[6-9]{1,4}[)]{0,1}[-\s0-9]*$'),
          ),
        ],
        validator: (value) {
          if (value?.length != 10) {
            return 'Please Enter your PhoneNumber';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        controller: controller,
      ),
    );
  }

  Widget _buildDropdown({
    required RxString value, // Use RxString here
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Obx(() =>
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
              value: value.value,
              // Access the observable value
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down_sharp),
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
        ));
  }


  Widget updateButton({
    String? text,
    void Function()? onTap,
    Color? Color,
    Color? textcolor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60.h,
        width: 350.w,
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textcolor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}