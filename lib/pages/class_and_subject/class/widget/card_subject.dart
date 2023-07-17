import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardTodoListWidget extends ConsumerWidget {
  final Color color;
  final String title;
  final String description;
  final void Function()? onPressed;
  final bool isShowEdit;
  const CardTodoListWidget({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    required this.isShowEdit,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Container(
              width: 10.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: TextWidget(
                        text: title,
                        textAlign: TextAlign.left,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      subtitle: TextWidget(
                        text: description,
                        textAlign: TextAlign.left,
                        fontSize: 15.sp,
                        color: AppTheme.dismissibleBackground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isShowEdit)
              IconButton(
                  iconSize: 20.sp,
                  icon: const Icon(Icons.edit),
                  onPressed: onPressed),
          ],
        ),
      ),
    );
  }
}
