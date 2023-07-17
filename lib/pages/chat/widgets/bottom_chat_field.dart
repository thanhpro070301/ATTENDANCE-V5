import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' as foundation;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:gap/gap.dart';
import 'package:attendance_/common/enum/message_enum.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/chat/controller/chat_controller.dart';
import 'package:attendance_/pages/chat/widgets/message_reply_preview.dart';
import 'package:attendance_/provider/message_reply_provider.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const BottomChatField({
    super.key,
    required this.receiverUserId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final messageController = TextEditingController();
  File? image;
  File? video;
  late FlutterSoundRecorder _soundCorder;
  bool isRecordInit = false;
  bool isRecording = false;
  bool isShowSendButton = false;
  bool emojiShowing = false;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();

    _soundCorder = FlutterSoundRecorder();
    initializeAudio();
  }

  Future<void> initializeAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundCorder.openRecorder();
    isRecordInit = true;
  }

  Future<void> closeAudio() async {
    await _soundCorder.closeRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    closeAudio();

    isRecordInit = false;
  }

  void sentTextMessage() async {
    HapticFeedback.heavyImpact();
    if (isShowSendButton && messageController.text.isNotEmpty) {
      ref.read(chatControllerProvider.notifier).sentTextMessage(
          context: context,
          text: messageController.text.trim(),
          receiverUserId: widget.receiverUserId,
          isGroupChat: widget.isGroupChat);
      messageController.clear();
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecordInit) {
        return;
      }
      if (isRecording) {
        await _soundCorder.stopRecorder();
        sentFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundCorder.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sentFileMessage(File file, MessageEnum messageType) {
    HapticFeedback.heavyImpact();
    ref.read(chatControllerProvider.notifier).sentFileMessage(
        context: context,
        file: file,
        messageType: messageType,
        receiverUserId: widget.receiverUserId,
        isGroupChat: widget.isGroupChat);
  }

  void selectImage() async {
    HapticFeedback.heavyImpact();
    image = await pickImageFromGallery(context);
    if (image != null) {
      sentFileMessage(image!, MessageEnum.image);
    }
  }

  void selectVideo() async {
    HapticFeedback.heavyImpact();
    video = await pickVideoFromGallery(context);
    if (video != null) {
      sentFileMessage(video!, MessageEnum.video);
    }
  }

  void selectGIF() async {
    HapticFeedback.heavyImpact();
    final gif = await pickGIF(context);

    if (gif != null) {
      if (context.mounted) {
        ref.read(chatControllerProvider.notifier).sentGIF(
              context: context,
              gifUrl: gif.url,
              messageType: MessageEnum.gif,
              receiverUserId: widget.receiverUserId,
              isGroupChat: widget.isGroupChat,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                style: AppTheme.body1.copyWith(color: AppTheme.darkText),
                focusNode: focusNode,
                controller: messageController,
                onChanged: (value) {
                  if (value.isNotEmpty && messageController.text.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.nearlyWhite,
                    prefixIcon: SizedBox(
                      width: 70.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Gap(5.w),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              setState(() {
                                emojiShowing = !emojiShowing;
                              });
                            },
                            child: Icon(
                              CupertinoIcons.smiley_fill,
                              color: Colors.grey,
                              size: 20.r,
                            ),
                          ),
                          Gap(5.w),
                          GestureDetector(
                            onTap: selectGIF,
                            child: Icon(
                              Icons.gif_box_outlined,
                              color: Colors.grey,
                              size: 20.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                    suffixIcon: SizedBox(
                      width: context.screenSize.width / 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: selectImage,
                            child: Icon(
                              CupertinoIcons.camera,
                              color: Colors.grey,
                              size: 20.r,
                            ),
                          ),
                          Gap(5.w),
                          GestureDetector(
                            onTap: selectVideo,
                            child: Icon(
                              CupertinoIcons.film_fill,
                              color: Colors.grey,
                              size: 20.r,
                            ),
                          ),
                          Gap(10.w)
                        ],
                      ),
                    ),
                    hintText: 'Aa',
                    hintStyle: AppTheme.body2
                        .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: AppTheme.borderColor.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: AppTheme.borderColor.withOpacity(0.5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide(
                          width: 0.5,
                          style: BorderStyle.solid,
                          color: AppTheme.borderColor.withOpacity(0.5)),
                    ),
                    contentPadding: EdgeInsets.all(10.w)),
              ),
            ),
            GestureDetector(
              onTap: sentTextMessage,
              child: Padding(
                padding: EdgeInsets.all(7.w),
                child: CircleAvatar(
                  backgroundColor: AppTheme.nearlyBlue,
                  radius: 22.r,
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Ionicons.close
                            : Ionicons.mic_outline,
                    size: 24.r,
                    color: AppTheme.nearlyWhite,
                  ),
                ),
              ),
            )
          ],
        ),
        Offstage(
          offstage: !emojiShowing,
          child: SizedBox(
              height: 250.h,
              child: EmojiPicker(
                textEditingController: messageController,
                config: Config(
                  columns: 7,
                  emojiSizeMax: 32 *
                      (foundation.defaultTargetPlatform == TargetPlatform.iOS
                          ? 1.30
                          : 1.0),
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  initCategory: Category.RECENT,
                  bgColor: const Color(0xFFF2F2F2),
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  backspaceColor: Colors.blue,
                  skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: true,
                  recentsLimit: 28,
                  replaceEmojiOnLimitExceed: false,
                  noRecents: const Text(
                    'No Recents',
                    style: TextStyle(fontSize: 20, color: Colors.black26),
                    textAlign: TextAlign.center,
                  ),
                  loadingIndicator: const SizedBox.shrink(),
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                  checkPlatformCompatibility: true,
                ),
              )),
        ),
      ],
    );
  }
}
