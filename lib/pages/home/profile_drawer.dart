import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/app_home_chatscreen/mobile_layout_screen.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/auth/verification_confirmation.dart';
import 'package:attendance_/pages/user_profile/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void navigateToUserProfile(BuildContext context, String uid) {
    Navigator.push(
      context,
      PageTransition(
        curve: Curves.bounceOut,
        type: PageTransitionType.rotate,
        alignment: Alignment.topCenter,
        child: UserProfile(uid: uid),
      ),
    );
  }

  void signOut(BuildContext context, WidgetRef ref) {
    final authProvider = ref.watch(authControllerProvider.notifier);
    authProvider.logout(context);
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Gap(10.h),
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 50.r,
            ),
            Gap(10.h),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                user.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Gap(15.h),
            const Divider(),
            ListTile(
              title: const Text('Trang cá nhân', style: AppTheme.body2),
              leading: Icon(CupertinoIcons.person_crop_circle, size: 25.r),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            Gap(10.h),
            ListTile(
              title: const Text('Tin nhắn', style: AppTheme.body2),
              leading: Icon(CupertinoIcons.chat_bubble_2_fill, size: 25.r),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: const MobileLayoutScreen(),
                  ),
                );
              },
            ),
            Gap(10.h),
            ListTile(
                title: const Text('Đăng xuất', style: AppTheme.body2),
                leading:
                    Icon(CupertinoIcons.arrow_left_square_fill, size: 25.r),
                onTap: () => signOut(context, ref)),
            Gap(10.h),
          ],
        ),
      ),
    );
  }
}
