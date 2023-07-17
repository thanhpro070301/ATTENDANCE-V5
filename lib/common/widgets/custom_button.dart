import 'package:flutter/material.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(AppTheme.nearlyWhite),
        backgroundColor:
            MaterialStateProperty.all<Color>(AppTheme.nearlyDarkBlue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      child: Center(
          child: Text(
        text,
        style: TextStyle(fontSize: 16.sp),
      )),
    );
  }
}
