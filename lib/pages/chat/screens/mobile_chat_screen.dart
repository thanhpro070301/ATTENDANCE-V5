import 'package:attendance_/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/chat/widgets/bottom_chat_field.dart';
import 'package:attendance_/pages/chat/widgets/chat_list.dart';
import 'package:gap/gap.dart';
import 'package:ionicons/ionicons.dart';

class MobileChatScreen extends ConsumerStatefulWidget {
  static const routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  const MobileChatScreen({
    Key? key,
    required this.isGroupChat,
    required this.name,
    required this.profilePic,
    required this.uid,
  }) : super(key: key);

  @override
  ConsumerState<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends ConsumerState<MobileChatScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        debugPrint('Resumed');
        ref.read(authControllerProvider.notifier).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        debugPrint('Inactive');
        ref.read(authControllerProvider.notifier).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.darkerText,
        elevation: 0,
        title: widget.isGroupChat
            ? SizedBox(
                width: context.screenSize.width / 3,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.profilePic),
                      radius: 20,
                    ),
                    Text(
                      widget.name,
                      style: AppTheme.body2.copyWith(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              )
            : ref.watch(getUserDataByIdProvider(widget.uid)).when(
                  data: (data) => Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(data.profilePic),
                        radius: 20,
                      ),
                      Gap(7.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: context.screenSize.width / 3,
                            child: Text(
                              data.name,
                              style: AppTheme.body2.copyWith(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          Row(
                            children: [
                              data.isOnline
                                  ? Icon(Ionicons.ellipse,
                                      color: Colors.green, size: 10.r)
                                  : Icon(Ionicons.ellipse,
                                      color: Colors.grey, size: 10.r),
                              Gap(4.w),
                              Text(
                                overflow: TextOverflow.ellipsis,
                                data.isOnline
                                    ? "đang hoạt động"
                                    : "không hoạt động",
                                style: AppTheme.body2.copyWith(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  error: (error, stackTrace) =>
                      ErrorText(text: error.toString()),
                  loading: () => const Loader(),
                ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
                receiverUserId: widget.uid, isGroupChat: widget.isGroupChat),
          ),
          BottomChatField(
              receiverUserId: widget.uid, isGroupChat: widget.isGroupChat),
        ],
      ),
    );
  }
}
