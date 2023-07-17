import 'package:flutter/material.dart';
import 'package:attendance_/common/enum/message_enum.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/chat/widgets/display_text_image_gif.dart';

import 'package:swipe_to/swipe_to.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.messageReplyType,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;
  final String username;
  final VoidCallback onRightSwipe;
  final MessageEnum messageReplyType;
  final String repliedText;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.r)),
            color: AppTheme.nearlyWhite,
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            child: Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      left: message.length < 5.w ? 15.w : 10.w,
                      right: 30.w,
                      top: 5.h,
                      bottom: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isReplying) ...[
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5.w),
                            margin: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.nearlyDarkBlue.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: DisplayTextImageGIF(
                              message: repliedText,
                              type: messageReplyType,
                            ),
                          ),
                        ],
                        DisplayTextImageGIF(
                          message: message,
                          type: type,
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
