import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:attendance_/common/values/theme.dart';

import 'package:attendance_/common/widgets/custom_widget_day.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/attendance/controller/attendance_controller.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/class_and_subject/class/controller/class_controller.dart';
import 'package:attendance_/pages/lessons_attendance_for_student/widgets/card_attendance.dart';

class LessonAttendanceForStudent extends ConsumerStatefulWidget {
  static const routeName = '/lesson-attendance-for-student';
  const LessonAttendanceForStudent({super.key});

  @override
  ConsumerState<LessonAttendanceForStudent> createState() =>
      _LessonAttendanceForStudentState();
}

class _LessonAttendanceForStudentState
    extends ConsumerState<LessonAttendanceForStudent>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late int todayIndex;
  late UserModel user;
  late String date;

  DateTime now = DateTime.now();
  late TabController tabController;
  List<String> weekdays = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
  List<DateTime> days = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    // getAddress();

    DateTime now = DateTime.now();
    tabController =
        TabController(length: 7, vsync: this, initialIndex: now.weekday - 1);

    for (int i = -now.weekday + 1; i <= 7 - now.weekday; i++) {
      days.add(now.add(Duration(days: i)));
    }

    todayIndex = days.indexWhere((date) =>
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
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
    final DateFormat formatter = DateFormat('MMM, yyyy');
    final String monthYear = formatter.format(now);
    user = ref.watch(userProvider)!;
    date = ref.watch(getDateCurrentProvider);
    final isLoading = ref.watch(attendanceControllerProvider);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppTheme.darkText,
        title: Text(
          'Danh sách điểm danh',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
            color: AppTheme.darkText,
          ),
        ),
        backgroundColor: AppTheme.nearlyWhite,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(5.h),
                CustomDayWidget(
                  monthYear: monthYear,
                  tabController: tabController,
                  weekdays: weekdays,
                  days: days,
                  todayIndex: todayIndex,
                ),
                ref
                    .watch(getAttendanceClassByDateProvider(
                        AttendanceQuery(user.uid, date)))
                    .when(
                      data: (data) {
                        if (data.isEmpty) {
                          return Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              'Không có danh sách điểm danh nào cho ngày đã chọn!!',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                                color: kDefaultIconDarkColor,
                              ),
                            ),
                          );
                        }

                        return AnimationLimiter(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final attendance = data[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                      child: ref
                                          .watch(getClassByIdProvider(
                                              attendance.idClass))
                                          .when(
                                            data: (dataClass) => ref
                                                .watch(getUserDataByIdProvider(
                                                    dataClass!.uidCreator))
                                                .when(
                                                  data: (data) {
                                                    return CardAttendance(
                                                        nameClass:
                                                            dataClass.nameClass,
                                                        nameCreator: data.name,
                                                        attendanceTime:
                                                            attendance
                                                                .timeAttendance,
                                                        deviceName: attendance
                                                            .deviceName,
                                                        idClass: dataClass.id,
                                                        secondsAttendance:
                                                            dataClass
                                                                .endAttendance,
                                                        location:
                                                            attendance.location,
                                                        onTap: () {
                                                          HapticFeedback
                                                              .heavyImpact();
                                                          ref
                                                              .read(
                                                                  attendanceControllerProvider
                                                                      .notifier)
                                                              .updateAttendanceClassByStudentId(
                                                                idStudent:
                                                                    user.uid,
                                                                classId:
                                                                    attendance
                                                                        .idClass,
                                                                context:
                                                                    context,
                                                              );
                                                        });
                                                  },
                                                  error: (error, stackTrace) =>
                                                      ErrorText(
                                                          text:
                                                              error.toString()),
                                                  loading: () =>
                                                      const Loader2(),
                                                ),
                                            error: (error, stackTrace) =>
                                                ErrorText(
                                                    text: error.toString()),
                                            loading: () => const Loader2(),
                                          )),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader2(),
                    ),
              ],
            ),
          ),
          if (isLoading)
            const Align(
              alignment: Alignment.center,
              child: Loader(),
            ),
        ],
      ),
    );
  }
}
