import 'package:attendance_/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:gap/gap.dart';

class MyTool extends StatelessWidget {
  const MyTool({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final Icon icon;
  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(top: 15.w),
        height: 70.w,
        width: 70.w,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppTheme.nearlyDarkBlue,
            HexColor('#6A88E5'),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          color: AppTheme.nearlyDarkBlue.withOpacity(0.9),
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Column(
          children: [
            Icon(icon.icon, color: AppTheme.nearlyWhite, size: 25.r),
            Gap(4.h),
            Text(
              text,
              style: AppTheme.body2
                  .copyWith(fontSize: 14.sp, color: AppTheme.nearlyWhite),
            ),
          ],
        ),
      ),
    );
  }
}
