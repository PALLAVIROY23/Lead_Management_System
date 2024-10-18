import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Button extends StatelessWidget {
  final String buttonText;
  final double height;
  final double width;
  final Color color;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  Button({super.key,
    required this.buttonText,
    required this.height,
    required this.width,
    required this.color,
    required this.borderRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height.h,
        width: width.w,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: color,
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
