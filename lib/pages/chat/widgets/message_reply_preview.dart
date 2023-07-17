import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:attendance_/pages/chat/widgets/display_text_image_gif.dart';
import 'package:attendance_/provider/message_reply_provider.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);

  void cancelReply(WidgetRef ref) {
    HapticFeedback.heavyImpact();
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      width: 350.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'Bạn' : '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                child: Icon(
                  CupertinoIcons.clear_circled_solid,
                  size: 16.r,
                ),
                onTap: () => cancelReply(ref),
              ),
            ],
          ),
          Gap(8.h),
          DisplayTextImageGIF(
            message: messageReply.message,
            type: messageReply.messageEnum,
          ),
        ],
      ),
    );
  }
}
