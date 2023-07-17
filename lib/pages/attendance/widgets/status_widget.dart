import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:attendance_/common/values/theme.dart';

import 'package:attendance_/common/widgets/text_widget.dart';

class StatusWidget extends StatelessWidget {
  final String text;
  final Color color;

  const StatusWidget({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: color,
            border: Border.all(
              color: AppTheme.darkerText,
            ),
          ),
        ),
        Gap(4.w),
        TextWidget(
          text: text,
          color: AppTheme.darkerText,
          fontWeight: FontWeight.w600,
          fontSize: 15.sp,
        ),
      ],
    );
  }
}
