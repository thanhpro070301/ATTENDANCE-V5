import 'package:attendance_/common/values/constants.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

final currentIndexProvider = StateProvider((ref) => 0);

class AppHomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/app-home-screen';
  const AppHomeScreen({super.key});

  @override
  ConsumerState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends ConsumerState<AppHomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    animationController?.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppTheme.background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: ref
              .watch(constantControllerProvider.notifier)
              .tabWidgets[ref.watch(currentIndexProvider)],
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: ref.watch(currentIndexProvider),
            onTap: (i) {
              HapticFeedback.heavyImpact();

              ref.read(currentIndexProvider.notifier).state = i;
            },
            items: [
              SalomonBottomBarItem(
                icon: Icon(CupertinoIcons.home, size: 20.r),
                title: Text(
                  "Trang chủ",
                  style: AppTheme.body1.copyWith(fontSize: 15.sp),
                ),
                selectedColor: Colors.purple,
              ),
              SalomonBottomBarItem(
                icon: Icon(CupertinoIcons.rectangle_on_rectangle_angled,
                    size: 20.r),
                title: Text("Nhóm",
                    style: AppTheme.body1.copyWith(fontSize: 15.sp)),
                selectedColor: Colors.pink,
              ),
              SalomonBottomBarItem(
                icon:
                    Icon(CupertinoIcons.square_stack_3d_down_right, size: 20.r),
                title: Text("Chủ đề",
                    style: AppTheme.body1.copyWith(fontSize: 15.sp)),
                selectedColor: Colors.orange,
              ),
              SalomonBottomBarItem(
                icon: Icon(CupertinoIcons.list_bullet_indent, size: 20.r),
                title: Text("DSĐ.Danh",
                    style: AppTheme.body1.copyWith(fontSize: 15.sp)),
                selectedColor: Colors.teal,
              ),
            ],
          ),
        ));
  }
}
