import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../../customWidgets/CustomTextField.dart';
import '../../../../customWidgets/color_extension.dart';
import '../controllers/view_screen_controller.dart';

class ViewScreenView extends GetView<ViewScreenController> {
  const ViewScreenView({super.key});
  @override
  Widget build(BuildContext context) {
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
        backgroundColor: HexColor.fromHex(" #FFFFFF"),
      ),
      backgroundColor: HexColor.fromHex(" #FFFFFF"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
        Container(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTextRow("Name", controller.args["name"]),
            SizedBox(height: 20.h),
            buildTextRow("Phone", controller.args["mobile"]),
            SizedBox(height: 20.h),
            buildTextRow("City", controller.args["address"]),
            SizedBox(height: 20.h),
            buildTextRow("Status", controller.args["status"]),
            SizedBox(height: 20.h),
            buildTextRow("Service", controller.args["service"]),
            SizedBox(height: 20.h),
            buildTextRow("Source", controller.args["source"]),
            SizedBox(height: 20.h),
            buildTextRow("Company", controller.args["companyname"]),
            SizedBox(height: 20.h),
            buildTextRow("LastUpDate", controller.args["lastupdate"]),
            SizedBox(height: 20.h),
            buildTextRow("Follow up date", controller.args["followupdate"]),
            SizedBox(height: 20.h),
            buildTextRow("Testing", controller.args["services"]),
          ],
        ),
      ),
                SizedBox(height: 20.h,),
                CustomTextField(
                  HintText: "Write Comment",
                  height: 55.h,
                  Radius: 25,
                  width: 350.w,
                  keyboardType: TextInputType.name,
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  obscureText: false,
                  isOutlineInputBorder: false,
                  outlineborder: const OutlineInputBorder(borderSide: BorderSide.none),
                  onchangeFuntion:  (value) {
                    controller.comment.value = value; // Update the comment value
                  },
                ),
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
                    child: DropdownButton<dynamic>(
                      value: controller.selectedStatus.value,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      onChanged: (dynamic? newValue) {
                        if (newValue != null) {
                          controller.updateSelectedStatus(newValue);
                        }
                      },
                      underline: Container(), // Removing the underline
                      items: controller.status
                          .map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                )),
                SizedBox(height: 20.h),
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

                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    myButton(
                        onTap: () {
                          controller.validateInputs();
                        },
                        height: 80.h,
                        width: 150.w,
                        text: "Submit Details",
                        Color: HexColor.fromHex("#1D4288"),
                        textcolor: Colors.white),
                    myButton(
                        onTap: () {Get.back();},
                        height: 80.h,
                        width: 150.w,
                        text: "Close",
                        Color: HexColor.fromHex("#ed2d2c"),
                        textcolor: Colors.white)
                  ],
                )
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 20.w, vertical: 15.h),
      ),
    );
  }
}

Widget myButton({
  String? text,
  void Function()? onTap,
  Color? Color,
  Color? textcolor,
  double? height,
  double? width,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height ?? Get.height * 0.05,
      width: width ?? Get.width * 0.4,
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
                color: textcolor),
          ),
        ],
      ),
    ),
  );
}

Widget buildTextRow(String label, String? value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "$label: ",
        style: TextStyle(fontSize: 18.sp, color: Colors.black),
      ),
      SizedBox(width: 10.w,),
      Expanded(
        child: Text(
          value ?? ' ',
          style: TextStyle(fontSize: 18.sp, color: Colors.black),
        ),
      ),
    ],
  ).paddingOnly(right: 50);
}