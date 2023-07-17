import 'dart:async';
import 'package:attendance_/common/values/path_provider.dart';
import 'package:attendance_/common/values/save_read_excel.dart';
import 'package:attendance_/models/attendance_for_class/attendance_for_class_model.dart';
import 'package:attendance_/models/attendance_for_lesson_model/attendance_model.dart';
import 'package:attendance_/pages/user_profile/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:attendance_/common/enum/status_attendance_enum.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/pages/attendance/controller/attendance_controller.dart';
import 'package:attendance_/pages/attendance/widgets/status_widget.dart';
import 'package:attendance_/pages/class_and_subject/class/controller/class_controller.dart';
import 'package:attendance_/pages/lesson_class/controller/lesson_controller.dart';
import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:attendance_/provider/status_attendance_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/quickalert.dart';

final remainingTimeForClassProvider = StateProvider.autoDispose((ref) => 0);
final remainingTimeForLessonProvider = StateProvider((ref) => 0);
final isAttendanceClassProvider = StateProvider<bool?>((ref) => null);

class AttendanceScreen extends ConsumerStatefulWidget {
  static const routeName = '/attendance-screen';
  final String idLesson;
  final String lessonName;
  final String idClass;
  final String nameClass;
  final String secondsAttendance;
  const AttendanceScreen({
    super.key,
    required this.idLesson,
    required this.lessonName,
    required this.idClass,
    required this.nameClass,
    required this.secondsAttendance,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  Timer? timerOfClass;
  Timer? timerOfLesson;
  late TabController _tabController;
  bool showFloatingActionButton = false;
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

  static List<Tab> myTabs = <Tab>[
    const Tab(
      text: "Buổi học",
    ),
    const Tab(
      text: 'Học viên',
    ),
  ];
  void _handleTabSelection() {
    HapticFeedback.heavyImpact();
    setState(() {
      showFloatingActionButton = _tabController.index == 1;
    });
  }

  @override
  void initState() {
    super.initState();
    getPublicDirectoryPath(ref);
    if (widget.idClass.isNotEmpty) {
      loadRemainingTime();

      if (ref.read(remainingTimeForClassProvider) < 0) {
        timerOfClass!.cancel();
      }
    } else {
      loadRemainingTime();

      if (ref.read(remainingTimeForLessonProvider) < 0) {
        timerOfLesson!.cancel();
      }
    }
    _tabController = TabController(vsync: this, length: myTabs.length);
    _handleTabSelection();
    WidgetsBinding.instance.addObserver(this);
  }

  void loadRemainingTime() async {
    if (widget.idClass.isNotEmpty) {
      final difference = await ref
          .read(classControllerProvider.notifier)
          .getEndTimeAttendanceOfClass(widget.idClass);

      ref.read(remainingTimeForClassProvider.notifier).state = difference;
      startTimer();
    } else {
      final difference = await ref
          .read(lessonControllerProvider.notifier)
          .getEndTimeAttendanceOfLesson(widget.idLesson);

      ref.read(remainingTimeForLessonProvider.notifier).state = difference;
      startTimer();
    }
  }

  void startCountdown() {
    HapticFeedback.heavyImpact();
    if (widget.idClass.isNotEmpty) {
      ref
          .read(classControllerProvider.notifier)
          .updateEndAttendanceForClass(widget.idClass);
      ref.read(isAttendanceClassProvider.notifier).update((state) => true);
      ref.read(remainingTimeForClassProvider.notifier).state = 90;
      startTimer();
    } else {
      ref
          .read(lessonControllerProvider.notifier)
          .updateEndAttendanceForLesson(widget.idLesson);

      ref.read(remainingTimeForLessonProvider.notifier).state = 90;
      startTimer();
    }
  }

  void closeAttendance() {
    if (widget.idClass.isNotEmpty) {
      if (ref.read(remainingTimeForClassProvider) <= 0 &&
          ref.read(isAttendanceClassProvider.notifier).state == false) {
        ref.read(isAttendanceClassProvider.notifier).update((state) => null);

        ref
            .read(attendanceControllerProvider.notifier)
            .updateAbsentAttendanceByClass(widget.idClass);
      }
    }
  }

  void startTimer() {
    if (widget.idClass.isNotEmpty) {
      if (timerOfClass != null && timerOfClass!.isActive) {
        timerOfClass!.cancel();
      }

      timerOfClass = Timer.periodic(const Duration(seconds: 1), (timer) {
        ref.read(remainingTimeForClassProvider.notifier).state--;
        ref.read(isAttendanceClassProvider.notifier).state == true;

        if (ref.read(remainingTimeForClassProvider) < 0) {
          timer.cancel();
          ref.read(isAttendanceClassProvider.notifier).update((state) => false);

          ref.read(remainingTimeForClassProvider.notifier).state = 0;
          closeAttendance();
        }
      });
    } else {
      if (timerOfLesson != null && timerOfLesson!.isActive) {
        timerOfLesson!.cancel();
      }

      timerOfLesson = Timer.periodic(const Duration(seconds: 1), (timer) {
        ref.read(remainingTimeForLessonProvider.notifier).state--;

        if (ref.read(remainingTimeForLessonProvider) < 0) {
          timer.cancel();
          ref.read(remainingTimeForLessonProvider.notifier).state = 0;
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timerOfClass?.cancel();
    timerOfLesson?.cancel();
    _tabController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void _changeColor(String statusAttendance, String id) {
    HapticFeedback.heavyImpact();
    int counter = ref.watch(counterProvider);
    if (counter == 0) {
      ref.read(buttonColorProvider.notifier).state = Colors.green;
      ref.read(statusAttendanceProvider.notifier).state =
          StatusAttendance.present;
    } else if (counter == 1) {
      ref.read(buttonColorProvider.notifier).state = Colors.red;
      ref.read(statusAttendanceProvider.notifier).state =
          StatusAttendance.absent;
    } else {
      ref.read(buttonColorProvider.notifier).state = Colors.green;
      ref.read(statusAttendanceProvider.notifier).state =
          StatusAttendance.present;
    }

    ref.read(counterProvider.notifier).state = (counter + 1) % 3;

    if (widget.idLesson.isNotEmpty) {
      ref.read(attendanceControllerProvider.notifier).updateStatusForLesson(
            context: context,
            statusAttendance: statusAttendance,
            id: id,
            idLesson: widget.idLesson,
          );
    }

    if (widget.idClass.isNotEmpty) {
      ref.read(attendanceControllerProvider.notifier).updateStatusForClass(
            context: context,
            statusAttendance: statusAttendance,
            id: id,
            idClass: widget.idClass,
          );
    }
    ref.read(counterProvider.notifier).state = (counter + 1) % 2;
  }

  void navigateToUserProfile(String uid) {
    Navigator.push(
      context,
      PageTransition(
        curve: Curves.bounceOut,
        type: PageTransitionType.leftToRight,
        alignment: Alignment.topCenter,
        child: UserProfile(
          uid: uid,
        ),
      ),
    );
  }

  String message = '';

  Future showAlert() async {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Lưu',
      customAsset: 'assets/capoo.gif',
      widget: TextFormField(
        style: AppTheme.body2.copyWith(color: AppTheme.darkText),
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Nhập SĐT cách nhau 1 dấu ,',
          prefixIcon: Icon(
            CupertinoIcons.phone_fill_badge_plus,
          ),
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.phone,
        onChanged: (value) => message = value,
      ),
      onConfirmBtnTap: () async {
        if (message.length < 5) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Số điện thoại bạn nhập k tồn tại',
          );
          return;
        }
        Set<String> userSet = {};
        String input = message;
        List<String> userPhone =
            input.split(",").map((id) => id.trim()).toList();
        userSet.addAll(userPhone);
        List<String> userPhoneList = userSet.toList();
        List<String> formattedUserList = userPhoneList.map((phoneNumber) {
          if (phoneNumber.startsWith("0")) {
            return "+84${phoneNumber.substring(1)}";
          } else {
            return phoneNumber;
          }
        }).toList();

        developer.log(userPhoneList.toString());
        ref
            .read(classControllerProvider.notifier)
            .addStudentForClass(context, widget.idClass, formattedUserList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppTheme.darkerText,
        title: widget.lessonName.isNotEmpty
            ? TextWidget(
                text: widget.lessonName,
                color: AppTheme.darkerText,
                fontWeight: FontWeight.w600,
                fontSize: 17.sp,
              )
            : showFloatingActionButton
                ? TextWidget(
                    text: 'Danh sách học sinh',
                    color: AppTheme.darkerText,
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                  )
                : TextWidget(
                    text: widget.nameClass,
                    color: AppTheme.darkerText,
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                  ),
      ),
      body: widget.idClass.isNotEmpty
          ? TabBarView(
              physics: const BouncingScrollPhysics(),
              controller: _tabController,
              children: [
                _attendanceScreen(),
                _studentOfClass(),
              ],
            )
          : _attendanceScreen(),
      floatingActionButton: showFloatingActionButton
          ? FloatingActionButton(
              backgroundColor: AppTheme.nearlyDarkBlue.withOpacity(0.8),
              onPressed: () async {
                HapticFeedback.heavyImpact();
                await showAlert();
              },
              child: const Icon(CupertinoIcons.add),
            )
          : null,
      bottomNavigationBar: widget.idClass.isNotEmpty ? _tabBar() : null,
    );
  }

  Widget _tabBar() {
    return Container(
      height: 60.h,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: AnimationLimiter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              TabBar(
                overlayColor: const MaterialStatePropertyAll<Color>(
                  Colors.transparent,
                ),
                physics: const BouncingScrollPhysics(),
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: AppTheme.nearlyDarkBlue,
                    width: 4.0,
                    strokeAlign: 8,
                  ),
                  insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                ),
                onTap: (index) => _handleTabSelection(),
                labelColor: AppTheme.nearlyDarkBlue,
                unselectedLabelColor: const Color(0xffA8A8A8),
                controller: _tabController,
                labelStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 17.h,
                ),
                tabs: myTabs.map((e) => e).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _studentOfClass() {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                ref.watch(getUserPhoneOfClassProvider(widget.idClass)).when(
                      data: (data) {
                        return AnimationLimiter(
                          child: ListView.builder(
                            itemCount: data.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              final student = data[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: ListTile(
                                      leading:
                                          const Icon(CupertinoIcons.person),
                                      title: Text(
                                        student,
                                        style: AppTheme.body2.copyWith(
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader(),
                    )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _attendanceScreen() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 13.w),
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                if (widget.idLesson.isNotEmpty)
                  ref
                      .watch(countAttendanceOfLessonProvider(widget.idLesson))
                      .when(
                        data: (data) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: "Sỉ số  $data",
                              color: AppTheme.darkerText,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                            if (ref.watch(remainingTimeForLessonProvider) < 0)
                              ref
                                  .watch(getLessonByIdProvider(widget.idLesson))
                                  .when(
                                    data: (data) {
                                      if (data != null &&
                                          data.endAttendance.isNotEmpty) {
                                        return exportExcelButtonByLesson();
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                    error: (error, stackTrace) =>
                                        ErrorText(text: error.toString()),
                                    loading: () => const Loader2(),
                                  ),
                          ],
                        ),
                        error: (error, stackTrace) =>
                            ErrorText(text: error.toString()),
                        loading: () => const Loader(),
                      ),
                Gap(10.h),
                //Class
                if (widget.idClass.isNotEmpty)
                  ref.watch(getUserPhoneOfClassProvider(widget.idClass)).when(
                        data: (data) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextWidget(
                              text: "Sỉ số  ${data.length}",
                              color: AppTheme.darkerText,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                            ref
                                .watch(getClassByIdProvider(widget.idClass))
                                .when(
                                  data: (data) {
                                    if (data != null &&
                                        data.endAttendance.isNotEmpty &&
                                        ref.watch(
                                                remainingTimeForClassProvider) ==
                                            0) {
                                      return exportExcelButtonByClass();
                                    } else {
                                      return const SizedBox();
                                    }
                                  },
                                  error: (error, stackTrace) =>
                                      ErrorText(text: error.toString()),
                                  loading: () => const Loader2(),
                                ),
                          ],
                        ),
                        error: (error, stackTrace) =>
                            ErrorText(text: error.toString()),
                        loading: () => const Loader(),
                      ),
                Gap(10.h),
                //Lesson
                if (widget.idLesson.isNotEmpty)
                  ref.watch(getLessonByIdProvider(widget.idLesson)).when(
                        data: (data) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatusWidget(
                                text: "Có mặt: ${data!.present}",
                                color: Colors.green,
                              ),
                              if (ref.watch(remainingTimeForLessonProvider) ==
                                  0)
                                OutlinedButton.icon(
                                  icon:
                                      const Icon(Icons.browse_gallery_outlined),
                                  label: const Text('Bắt đầu'),
                                  onPressed: () {
                                    HapticFeedback.heavyImpact();
                                    startCountdown();
                                  },
                                ),
                              if (ref.watch(remainingTimeForLessonProvider) !=
                                  0)
                                TextWidget(
                                  text:
                                      ' ${formatTime(ref.watch(remainingTimeForLessonProvider))}',
                                  color: AppTheme.darkerText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                ),
                            ],
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(text: error.toString()),
                        loading: () => const Loader(),
                      ),
                //Class

                if (widget.idClass.isNotEmpty)
                  ref.watch(getClassByIdProvider(widget.idClass)).when(
                        data: (data) {
                          return AnimationLimiter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 375),
                                childAnimationBuilder: (widget) =>
                                    SlideAnimation(
                                  horizontalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: widget,
                                  ),
                                ),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      StatusWidget(
                                        text: "Có mặt: ${data!.present}",
                                        color: Colors.green,
                                      ),
                                      Gap(15.w),
                                      StatusWidget(
                                        text: "Vắng: ${data.absent}",
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (ref.watch(
                                                  remainingTimeForClassProvider) ==
                                              0 &&
                                          data.endAttendance.isEmpty)
                                        OutlinedButton.icon(
                                            icon: const Icon(
                                                Icons.browse_gallery_outlined),
                                            label: const Text('Bắt đầu'),
                                            onPressed: () {
                                              HapticFeedback.heavyImpact();
                                              startCountdown();
                                            }),
                                      Gap(7.w),
                                      if (ref.watch(
                                                  remainingTimeForClassProvider) ==
                                              0 &&
                                          data.endAttendance.isNotEmpty)
                                        OutlinedButton.icon(
                                          icon: const Icon(
                                              CupertinoIcons.refresh_thin),
                                          label: const Text('Điểm danh lại'),
                                          onPressed: () {
                                            HapticFeedback.heavyImpact();
                                            ref
                                                .read(
                                                    attendanceControllerProvider
                                                        .notifier)
                                                .resetAttendanceByClass(
                                                    widget.idClass);
                                          },
                                        ),
                                      if (ref.watch(
                                              remainingTimeForClassProvider) !=
                                          0)
                                        TextWidget(
                                          text:
                                              ' ${formatTime(ref.read(remainingTimeForClassProvider.notifier).state)}',
                                          color: AppTheme.darkerText,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp,
                                        ),
                                    ],
                                  ),
                                  const Gap(5),
                                ],
                              ),
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(text: error.toString()),
                        loading: () => const Loader(),
                      ),
                //Lesson
                Gap(10.w),
                if (widget.idLesson.isNotEmpty)
                  ref
                      .watch(getAttendanceByLessonProvider(widget.idLesson))
                      .when(
                        data: (data) {
                          final status = ref.watch(statusAttendanceProvider);
                          return attendanceByLesson(data, status);
                        },
                        error: (error, stackTrace) =>
                            ErrorText(text: error.toString()),
                        loading: () => const Loader(),
                      ),

                if (widget.idClass.isNotEmpty)
                  //Class
                  ref.watch(getAttendanceByClassProvider(widget.idClass)).when(
                        data: (data) {
                          final status = ref.watch(statusAttendanceProvider);
                          return attendanceByClass(data, status);
                        },
                        error: (error, stackTrace) =>
                            ErrorText(text: error.toString()),
                        loading: () => const Loader(),
                      ),
                if (widget.idClass.isNotEmpty)
                  //Class
                  ref
                      .watch(getUserIsNotHaveAttendanceProvider(widget.idClass))
                      .when(
                        data: (data) {
                          return userNotHaveAttendance(data);
                        },
                        error: (error, stackTrace) =>
                            ErrorText(text: error.toString()),
                        loading: () => const Loader(),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AnimationLimiter attendanceByLesson(
      List<AttendanceModel> data, StatusAttendance status) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: data.length,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final studentAttendance = data[index];
          Color statusColor;
          switch (studentAttendance.statusAttendance) {
            case 'present':
              statusColor = Colors.green;
              break;
            case 'absent':
              statusColor = Colors.red;
              break;

            default:
              statusColor = Colors.transparent;
          }
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                  child: Container(
                margin: EdgeInsets.only(bottom: 10.w),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ref
                                .watch(getUserDataByIdProvider(
                                    studentAttendance.idStudent))
                                .when(
                                  data: (userOfLesson) => GestureDetector(
                                    onTap: () =>
                                        navigateToUserProfile(userOfLesson.uid),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(userOfLesson.profilePic),
                                    ),
                                  ),
                                  error: (error, stackTrace) =>
                                      ErrorText(text: error.toString()),
                                  loading: () => const Loader2(),
                                ),
                            Gap(5.w),
                            SizedBox(
                              width: context.screenSize.width / 1.8,
                              child: Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                studentAttendance.nameStudent,
                                style: AppTheme.body2.copyWith(fontSize: 15.sp),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: statusColor,
                              border: Border.all(
                                color: AppTheme.darkerText,
                              ),
                            ),
                          ),
                          onTap: () => _changeColor(
                            status.name,
                            data[index].id,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ),
          );
        },
      ),
    );
  }

  AnimationLimiter attendanceByClass(
      List<AttendanceForClassModel> data, StatusAttendance status) {
    return AnimationLimiter(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final studentAttendance = data[index];

          Color statusColor;
          switch (studentAttendance.statusAttendance) {
            case 'present':
              statusColor = Colors.green;
              break;
            case 'absent':
              statusColor = Colors.red;
              break;

            default:
              statusColor = Colors.transparent;
          }
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                  child: Container(
                margin: EdgeInsets.only(bottom: 10.w),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ref
                                .watch(getUserDataByIdProvider(
                                    studentAttendance.idStudent))
                                .when(
                                  data: (userOfClass) => GestureDetector(
                                    onTap: () =>
                                        navigateToUserProfile(userOfClass.uid),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(userOfClass.profilePic),
                                    ),
                                  ),
                                  error: (error, stackTrace) =>
                                      ErrorText(text: error.toString()),
                                  loading: () => const Loader2(),
                                ),
                            Gap(10.w),
                            Column(
                              children: [
                                SizedBox(
                                  width: context.screenSize.width / 1.6,
                                  child: Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    studentAttendance.nameStudent,
                                    style: AppTheme.body2
                                        .copyWith(fontSize: 15.sp),
                                  ),
                                ),
                                if (studentAttendance.timeAttendance.isNotEmpty)
                                  Gap(2.w),
                                if (studentAttendance.timeAttendance.isNotEmpty)
                                  SizedBox(
                                    width: context.screenSize.width / 1.6,
                                    child: Text(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      'Thời gian điểm danh: ${formatTimeAttendance(studentAttendance.timeAttendance)}',
                                      style: AppTheme.body2
                                          .copyWith(fontSize: 15.sp),
                                    ),
                                  ),
                              ],
                            ),
                            Gap(5.w),
                          ],
                        ),
                        InkWell(
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r),
                              color: statusColor,
                              border: Border.all(
                                color: AppTheme.darkerText,
                              ),
                            ),
                          ),
                          onTap: () => _changeColor(
                            status.name,
                            data[index].id,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ),
          );
        },
      ),
    );
  }

  AnimationLimiter userNotHaveAttendance(List<String> data) {
    return AnimationLimiter(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final isNotHaveAttendance = data[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                  child: Container(
                margin: EdgeInsets.only(bottom: 10.w),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      bottomRight: Radius.circular(20.r),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
                    child: Row(
                      children: [
                        Gap(10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: context.screenSize.width / 1.6,
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                '$isNotHaveAttendance ',
                                style: AppTheme.body2.copyWith(fontSize: 15.sp),
                              ),
                            ),
                            SizedBox(
                              width: context.screenSize.width / 1.6,
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                '(chưa tạo tài khoản)',
                                style: AppTheme.body2.copyWith(fontSize: 15.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ),
          );
        },
      ),
    );
  }

  OutlinedButton exportExcelButtonByLesson() {
    return OutlinedButton(
      child: const Text('Xuất Excel'),
      onPressed: () async {
        HapticFeedback.heavyImpact();
        final permission = await getPublicDirectoryPath(ref);
        if (permission) {
          ref.watch(getAttendanceByLessonProvider(widget.idLesson)).when(
                data: (data) {
                  for (int index = 0; index < data.length; index++) {
                    final studentAttendance = data[index];
                    studentData.add({
                      "index": index,
                      "name": studentAttendance.nameStudent,
                      "deviceName": studentAttendance.deviceName,
                      "location": studentAttendance.location,
                      "createdAt": studentAttendance.createdAt,
                    });
                  }
                },
                error: (error, stackTrace) => ErrorText(text: error.toString()),
                loading: () => const Loader(),
              );

          developer.log(studentData.toString());
          String now = DateFormat('dd-MM-yyyy-HH-mm-ss').format(DateTime.now());
          if (context.mounted) {
            await createExcelFile(context, ref, '${widget.nameClass}-$now');
          }
        } else {
          getPublicDirectoryPath(ref);
        }
      },
    );
  }

  OutlinedButton exportExcelButtonByClass() {
    return OutlinedButton(
      child: const Text('Xuất Excel'),
      onPressed: () async {
        HapticFeedback.heavyImpact();
        final permission = await getPublicDirectoryPath(ref);

        if (permission) {
          ref.read(getAttendanceByClassProvider(widget.idClass)).when(
                data: (data) {
                  for (int index = 0; index < data.length; index++) {
                    final studentAttendance = data[index];
                    studentDataSet.add({
                      "index": index,
                      "name": studentAttendance.nameStudent,
                      "deviceName": studentAttendance.deviceName,
                      "location": studentAttendance.location,
                      "timeAttendance": studentAttendance.timeAttendance,
                      "statusAttendance": studentAttendance.statusAttendance
                    });
                  }
                },
                error: (error, stackTrace) => ErrorText(text: error.toString()),
                loading: () => const Loader(),
              );

          developer.log(studentData.toString());
          String now = DateFormat('dd-MM-yyyy-HH-mm-ss').format(DateTime.now());
          if (context.mounted) {
            await createExcelFile(context, ref, '${widget.nameClass}-$now');
          }
        } else {
          getPublicDirectoryPath(ref);
        }
      },
    );
  }
}
