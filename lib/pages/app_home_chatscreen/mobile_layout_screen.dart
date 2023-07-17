import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/auth/verification_confirmation.dart';

import 'package:attendance_/pages/group/screens/create_group_screen.dart';
import 'package:attendance_/pages/select_contacts/screens/contacts_list.dart';
import 'package:attendance_/pages/select_contacts/screens/select_contact_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  static const routeName = '/mobile-layout';
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
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
        ref.read(authControllerProvider.notifier).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider.notifier).setUserState(false);
        break;
    }
  }

  void signOut() {
    final authProvider = ref.watch(authControllerProvider.notifier);
    authProvider.logout(context);
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.background,
        centerTitle: false,
        foregroundColor: AppTheme.nearlyBlack,
        title: TextWidget(
          text: 'Danh sách trò chuyện',
          color: AppTheme.darkerText,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert, size: 25.r, color: AppTheme.darkText),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Tạo nhóm chat',
                    style: AppTheme.body1.copyWith(fontSize: 17.sp)),
                onTap: () => Future(
                  () {
                    HapticFeedback.heavyImpact();
                    Navigator.pushNamed(context, CreateGroupScreen.routeName);
                  },
                ),
              )
            ],
          )
        ],
      ),
      body: const ContactsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          HapticFeedback.heavyImpact();

          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRightWithFade,
              alignment: Alignment.topCenter,
              child: const SelectContactScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.nearlyDarkBlue,
        child: Icon(
          CupertinoIcons.chat_bubble_fill,
          size: 25.r,
          color: Colors.white,
        ),
      ),
    );
  }
}
