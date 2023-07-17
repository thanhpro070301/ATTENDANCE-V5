import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:attendance_/pages/app_home_chatscreen/app_home_screen.dart';
import 'package:attendance_/pages/attendance/attendance.dart';
import 'package:attendance_/pages/class_and_subject/subject/controller/subject_controller.dart';
import 'package:attendance_/pages/details_subject_and_class/details_subject_and_class.dart';
import 'package:attendance_/pages/home/delegates/search_user_delegate.dart';
import 'package:attendance_/pages/home/profile_drawer.dart';
import 'package:attendance_/pages/class_and_subject/class/widget/card_subject.dart';
import 'package:attendance_/pages/class_and_subject/class/widget/item_class.dart';
import 'package:attendance_/pages/lesson_class/create_lesson_class_screen.dart';
import 'package:attendance_/pages/qr_app/qr_scanner/qr_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'dart:math' as math;
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/auth/verification_confirmation.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/class_and_subject/class/controller/class_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  void signOut() {
    HapticFeedback.heavyImpact();
    final authProvider = ref.watch(authControllerProvider.notifier);
    authProvider.logout(context);
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    ref.read(classControllerProvider.notifier).checkAttendanceOfUser(
          context,
          ref.read(userProvider)!,
        );
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

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: SizedBox(
          width: context.screenSize.width / 2.2,
          child: FittedBox(
            child: TextWidget(
              text: 'Xin chào ${user.name}!',
              color: AppTheme.darkerText,
              fontWeight: FontWeight.w600,
              fontSize: 25.sp,
            ),
          ),
        ),
        centerTitle: false,
        foregroundColor: AppTheme.darkerText,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchUserDelegate(ref: ref),
              );
            },
          ),
          Builder(builder: (context) {
            return IconButton(
              icon:
                  CircleAvatar(backgroundImage: NetworkImage(user.profilePic)),
              onPressed: () => displayEndDrawer(context),
            );
          }),
        ],
      ),
      endDrawer: const ProfileDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8.w),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: context.screenSize.width / 1.4,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    'Chúc bạn có một ngày tốt lành!',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.sp,
                      color: AppTheme.deactivatedText,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50.w,
                  height: 50.w,
                  child: FloatingActionButton.small(
                    tooltip: 'Quét QR',
                    backgroundColor: AppTheme.nearlyDarkBlue.withOpacity(0.9),
                    child: Icon(
                      Icons.qr_code_scanner_outlined,
                      color: Colors.white,
                      size: 30.r,
                    ),
                    onPressed: () {
                      HapticFeedback.vibrate();
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          child: const QrScannerScreen(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
            Gap(20.h),
            Text(
              "DS nhóm của bạn",
              style: AppTheme.body1
                  .copyWith(fontSize: 17.sp, fontWeight: FontWeight.bold),
            ),
            Gap(5.h),
            SizedBox(
              height: context.screenSize.height / 3,
              child: ref.watch(getClassProvider(user.uid)).when(
                    data: (data) {
                      if (data.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: context.screenSize.width / 3.5,
                                  height: context.screenSize.height / 8,
                                  child: FittedBox(
                                    child: Image.asset('assets/cloud.png',
                                        fit: BoxFit.cover,
                                        color: AppTheme.darkText),
                                  )),
                              const Gap(3),
                              SizedBox(
                                width: context.screenSize.width,
                                child: Column(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        'Thử tạo 1 nhóm trải nghiệm ngay nào!',
                                        style: AppTheme.body2.copyWith(
                                            color: AppTheme.darkText,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Gap(10.w),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.nearlyBlue,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.r))),
                                      icon:
                                          Icon(CupertinoIcons.add, size: 20.r),
                                      label: Text('Tạo nhóm',
                                          style: AppTheme.subtitle.copyWith(
                                              color: AppTheme.nearlyWhite)),
                                      onPressed: () {
                                        HapticFeedback.heavyImpact();
                                        Navigator.pushNamed(context,
                                            CreateLessonScreen.routeName,
                                            arguments: {
                                              'nameSubject': '',
                                              'idSubject': '',
                                            });
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final classIndex = data[index];
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.heavyImpact();
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.scale,
                                  alignment: Alignment.topCenter,
                                  duration: const Duration(milliseconds: 400),
                                  isIos: true,
                                  child: AttendanceScreen(
                                    idClass: classIndex.id,
                                    nameClass: classIndex.nameClass,
                                    secondsAttendance: classIndex.endAttendance,
                                    idLesson: '',
                                    lessonName: '',
                                  ),
                                ),
                              );
                            },
                            child: ItemClass(
                              nameClass: classIndex.nameClass,
                              quantityStudent: classIndex.listUserPhone.length,
                              idClass: classIndex.id,
                            ),
                          );
                        },
                      );
                    },
                    error: (error, stackTrace) => ErrorText(
                      text: error.toString(),
                    ),
                    loading: () => const Loader(),
                  ),
            ),
            Text("DS chủ đề",
                style: AppTheme.body1
                    .copyWith(fontSize: 17.sp, fontWeight: FontWeight.bold)),
            Gap(4.h),
            ref.watch(getSubjectProvider(user.uid)).when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: context.screenSize.width / 3.5,
                                height: context.screenSize.height / 8,
                                child: FittedBox(
                                  child: Image.asset('assets/no-task.png',
                                      fit: BoxFit.cover,
                                      color: AppTheme.darkText),
                                )),
                            Gap(5.w),
                            SizedBox(
                              width: context.screenSize.width,
                              child: Column(
                                children: [
                                  FittedBox(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      'Thử tạo 1 chủ đề trải nghiệm ngay nào!',
                                      style: AppTheme.body2.copyWith(
                                          color: AppTheme.darkText,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Gap(10.w),
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.nearlyBlue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.r))),
                                    icon: Icon(CupertinoIcons.add, size: 20.r),
                                    label: Text('Tạo chủ đề',
                                        style: AppTheme.subtitle.copyWith(
                                            color: AppTheme.nearlyWhite)),
                                    onPressed: () {
                                      ref
                                          .read(currentIndexProvider.notifier)
                                          .state = 2;
                                    },
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return AnimationLimiter(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final subject = data[index];
                          final int counter = math.Random().nextInt(100);
                          Color color = Colors.transparent;

                          switch (counter % 6) {
                            case 1:
                              color = Colors.blue;
                              break;
                            case 2:
                              color = Colors.purple;
                              break;
                            case 3:
                              color = Colors.yellow;
                              break;
                            case 4:
                              color = Colors.green;
                              break;
                            case 5:
                              color = Colors.orange;
                              break;
                            case 6:
                              color = Colors.lightBlue;
                              break;
                            case 7:
                              color = Colors.pink;
                              break;
                            case 8:
                              color = Colors.cyan;
                              break;

                            case 9:
                              color = Colors.tealAccent;
                              break;
                            case 0:
                              color = Colors.red;
                              break;
                            default:
                              color = Colors.transparent;
                          }

                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      HapticFeedback.heavyImpact();

                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.leftToRight,
                                          child: DetailsClassScreen(
                                            idSubject: subject.id,
                                            nameSubject: subject.nameSubject,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CardTodoListWidget(
                                      isShowEdit: false,
                                      title: subject.nameSubject,
                                      description:
                                          'Số buổi ${subject.lessons.length}',
                                      color: color,
                                    ),
                                  ),
                                ),
                              ));
                        },
                        separatorBuilder: (context, index) => Gap(5.w),
                      ),
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    text: error.toString(),
                  ),
                  loading: () => const Loader(),
                )
          ],
        ),
      ),
    );
  }
}
