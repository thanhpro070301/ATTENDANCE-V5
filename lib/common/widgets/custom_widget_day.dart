import 'package:attendance_/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:attendance_/common/values/theme.dart';
import 'dart:developer' as developer;

String dateNow = formatDate(DateTime.now());
final getDateCurrentProvider = StateProvider.autoDispose((ref) => dateNow);

class CustomDayWidget extends ConsumerWidget {
  const CustomDayWidget({
    super.key,
    required this.monthYear,
    required this.tabController,
    required this.weekdays,
    required this.days,
    required this.todayIndex,
  });

  final String monthYear;
  final TabController tabController;
  final List<String> weekdays;
  final List<DateTime> days;
  final int todayIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void selectedDay(int index) {
      String selectedDate = DateFormat('dd-MM-yyyy').format(days[index]);
      ref.read(getDateCurrentProvider.notifier).update((state) => selectedDate);
      developer.log(selectedDate);
      developer.log(ref.read(getDateCurrentProvider));
    }

    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            20.r,
          ),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: TabBar(
          controller: tabController,
          isScrollable: true,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorPadding: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          splashBorderRadius: BorderRadius.circular(100),
          labelPadding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          indicator: BoxDecoration(
            color: AppTheme.nearlyDarkBlue,
            gradient: LinearGradient(colors: [
              AppTheme.nearlyDarkBlue,
              HexColor('#6A88E5'),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            shape: BoxShape.circle,
          ),
          unselectedLabelColor: Colors.brown,
          tabs: [
            for (int i = 0; i < weekdays.length; i++)
              Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w),
                width: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50.r),
                  ),
                ),
                child: Tab(
                  iconMargin: EdgeInsets.zero,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: AnimationLimiter(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: ScaleAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            Text(
                              weekdays[i],
                              style: GoogleFonts.poppins(
                                fontSize: 100.sp,
                                fontWeight: i == todayIndex
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            Text(
                              days[i].day.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 80.sp,
                                fontWeight: i == todayIndex
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
          onTap: (value) {
            HapticFeedback.heavyImpact();
            selectedDay(value);
          }),
    );
  }
}
