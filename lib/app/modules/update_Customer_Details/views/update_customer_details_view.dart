import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../customWidgets/CustomTextField.dart';
import '../../../../customWidgets/color_extension.dart';
import '../../customerListScreen/model/citiesModel.dart';
import '../../customerListScreen/model/serviceModel.dart';
import '../../customerListScreen/model/sourceModel.dart';
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
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  controller: controller.customerName,
                ),
                SizedBox(height: 2.0.h),
                Text(
                  controller.customerNameError.value,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            )),
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  controller: controller.emailController,
                ),
                SizedBox(height: 2.0),
                Text(
                  controller.emailError.value,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            )),


            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMobileNumberField(controller.mobileNumber),
                SizedBox(height: 2.0),
                Text(
                  controller.mobileNumberError.value,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            )),

            _buildMobileNumberField(controller.alternateMobileNumber, "Alternate Mobile Number"),
            SizedBox(height: 20.h),
            Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  controller: controller.companyName,
                ),
                SizedBox(height: 8.0),
                Text(
                  controller.companyNameError.value,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            )),

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
                  items: controller.serviceList.map<DropdownMenuItem<CustomerService>>((CustomerService service) {
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
                child: DropdownButton<CitiesData>(
                  value: controller.selectedCity.value, // Use selectedCity from the controller
                  isExpanded: true,
                  hint: const Text("Select city "), // Display hint when no value is selected
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  onChanged: (CitiesData? newValue) {
                    if (newValue != null) {
                      controller.updateSelectedCity(newValue);
                    }
                  },
                  underline: Container(), // Removing the underline
                  items: controller.city.map<DropdownMenuItem<CitiesData>>((CitiesData city) {
                    return DropdownMenuItem<CitiesData>(
                      value: city, // Set the correct value
                      child: Text(city.name ?? ''), // Display the city name, handle null safety
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
                  hint: const Text("Customer Source"), // Display hint when no value is selected
                  icon: const Icon(Icons.arrow_drop_down_sharp),
                  onChanged: (SourceList? newValue) {
                    if (newValue != null) {
                      controller.updateSelectedSource(newValue);
                    }
                  },
                  underline: Container(), // Removing the underline
                  items: controller.sources
                      .map<DropdownMenuItem<SourceList>>((SourceList source) {
                    return DropdownMenuItem<SourceList>(
                      value: source,
                      child: Text(source.sourcename ?? "Unknown"),
                    );
                  }).toList(),
                ),
              ),
            )),
            SizedBox(height: 50.h),
            updateButton(
              text: "Update Details",
              onTap: () {
                if (controller.validateInputs()) {
                  controller.updateCustomerDetails();
                } else {
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