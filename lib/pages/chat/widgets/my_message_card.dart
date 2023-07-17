import 'package:attendance_/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:attendance_/common/enum/message_enum.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/chat/widgets/display_text_image_gif.dart';
import 'package:ionicons/ionicons.dart';

import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum messageType;
  final void Function()? onLeftSwipe;
  final MessageEnum messageReplyType;
  final String repliedText;
  final String username;
  final bool isSeen;

  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.messageType,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.username,
    required this.messageReplyType,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.screenSize.width - 45,
          ),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17.r)),
            color: AppTheme.nearlyBlue,
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
            child: Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                      left: message.length < 5.w ? 25.w : 10.w,
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
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(5.r)),
                            child: DisplayTextImageGIF(
                              message: repliedText,
                              type: messageReplyType,
                            ),
                          ),
                        ],
                        DisplayTextImageGIF(
                          message: message,
                          type: messageType,
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 1,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white60,
                        ),
                      ),
                      Gap(5.w),
                      Icon(
                        isSeen ? Ionicons.checkmark_done : Icons.done,
                        size: 20,
                        color: isSeen ? AppTheme.nearlyWhite : Colors.white60,
                      ),
                    ],
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
