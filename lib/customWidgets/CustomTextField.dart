// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, must_be_immutable, prefer_typing_uninitialized_variables, avoid_print, empty_catches

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {


  CustomTextField({
    Key? key,
    required this.HintText,
    this.PerfixIcon,
    required this.Radius,
    this.SurfixIcon,
    this.SurfixIconPerssedIcon,
    this.ValidationErrorMessage,
    required this.width,
    this.controller,


    required this.keyboardType,
    required this.obscureText,
    required this.isOutlineInputBorder,
    this.label,
    this.maxline,
    this.IsEnabled,
    this.lenghtofInput,
    this.Innercolor,
    this.IsAadhar,
    this.height,
    this.minline,
    this.FocusborderColor,
    this.onchangeFuntion,
    this.TextStyleforLabelText,
    this.TextStyleForHintText,
    this.validator,
    this.decoration,
    this.errortext,
    this.contentPadding,
    this.outlineborder,
    this.cursorColor,
    this.styleoftextfeild,
    this.onTap,
    this.onSubmitted,
    this.IsCreditCard,
    this.errorTextStyle,
    this.inputFormatters,


  }) : super(key: key);
  List<TextInputFormatter>? inputFormatters;
  int? lenghtofInput;
  double width, Radius;
  String HintText;
  String? ValidationErrorMessage;
  Widget? label;
  Widget? SurfixIcon, PerfixIcon;
  Function? SurfixIconPerssedIcon;
  TextEditingController? controller;
  TextInputType keyboardType;
  bool obscureText;
  double? height;
  bool? IsEnabled;
  TextStyle? TextStyleforLabelText, TextStyleForHintText, errorTextStyle;
  dynamic Innercolor;
  EdgeInsetsGeometry? contentPadding;
  var TextInputAction;
  int? maxline, minline;
  bool isOutlineInputBorder;
  bool? IsAadhar = false;
  bool? IsCreditCard;
  void Function(String)? onchangeFuntion;
  String? Function(String?)? validator;
  Color? FocusborderColor;
  String? errortext;
  Decoration? decoration;
  InputBorder? outlineborder;
  Color? cursorColor;
  TextStyle? styleoftextfeild;


  Function()? onTap;
  Function(String)? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          width: width,
          decoration: decoration ??
              BoxDecoration(
                  borderRadius: BorderRadius.circular(Radius),
                  color: Innercolor ?? Colors.white),
          child: TextFormField(
            onTap: onTap ?? () {},
            onFieldSubmitted: onSubmitted,
            cursorColor: cursorColor,
            maxLines: maxline ?? 1,
            textCapitalization: TextCapitalization.sentences,
            minLines: minline ?? 1,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            textInputAction: TextInputAction,
            style: styleoftextfeild ??
                TextStyle(color: Colors.black, fontSize: 16),
            inputFormatters:


            keyboardType == TextInputType.phone
                ? IsAadhar == true
                ? [
              CustomInputFormatter(),
              LengthLimitingTextInputFormatter(14)
            ]
                : IsCreditCard == true && IsAadhar != true
                ? [
              CustomInputFormatter(),
              LengthLimitingTextInputFormatter(19)
            ]
                : [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(
                  lenghtofInput ?? 10)
            ]
                : keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.allow(RegExp('[0-9.]+'))]
                : keyboardType == TextInputType.name
                ? [
              FilteringTextInputFormatter.allow(
                  RegExp(r'[a-zA-Z ]'))
            ]
                : [FilteringTextInputFormatter.singleLineFormatter],
            onChanged: onchangeFuntion,
            onTapOutside: (errormessage) {},
            decoration: InputDecoration(
                isCollapsed: true,
                focusedBorder: !isOutlineInputBorder
                    ? InputBorder.none
                    : OutlineInputBorder(
                  borderSide: BorderSide(
                      color: FocusborderColor ?? Colors.blueGrey),
                  borderRadius: BorderRadius.circular(Radius),
                ),
                contentPadding:
                EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                labelStyle:
                TextStyleforLabelText ?? TextStyle(color: Colors.black),
                label: label,
                enabled: IsEnabled ?? true,
                prefixIcon: PerfixIcon,
                suffixIcon: SurfixIcon,
                hintText: HintText,
                hintStyle: TextStyleForHintText ??
                    TextStyle(color: Colors.grey.shade600),
                border: isOutlineInputBorder
                    ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Radius))
                    : outlineborder),
          ),
        ),
        (errortext ?? '').isEmpty
            ? SizedBox()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              child: Text(errortext ?? "", style: errorTextStyle),
            )
          ],
        )
      ],
    );
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    text = text.replaceAll(RegExp(r'(\s)|(\D)'), '');

    int offset = newValue.selection.start;

    var subText =
    newValue.text.substring(0, offset).replaceAll(RegExp(r'(\s)|(\D)'), '');

    int realTrimOffset = subText.length;

// if (newValue.selection.baseOffset == 0) {

// return newValue;

// }

    var buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);

      var nonZeroIndex = i + 1;

      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(
            ' '); // Replace this with anything you want to put after each 4 numbers
      }

// This block is only executed once

      if (nonZeroIndex % 4 == 0 &&
          subText.length == nonZeroIndex &&
          nonZeroIndex > 4) {
        int moveCursorToRigth = nonZeroIndex ~/ 4 - 1;

        realTrimOffset += moveCursorToRigth;
      }

// This block is only executed once

      if (nonZeroIndex % 4 != 0 && subText.length == nonZeroIndex) {
        int moveCursorToRigth = nonZeroIndex ~/ 4;

        realTrimOffset += moveCursorToRigth;
      }
    }

    var string = buffer.toString();

    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: realTrimOffset));
  }
}