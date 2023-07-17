import 'package:attendance_/pages/qr_app/display_qr/display_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:slide_countdown/slide_countdown.dart';

class CardAttendance extends ConsumerStatefulWidget {
  final String idClass;
  final String nameClass;
  final String nameCreator;

  final String location;
  final String deviceName;
  final String attendanceTime;
  final VoidCallback onTap;
  final String secondsAttendance;

  const CardAttendance({
    required this.secondsAttendance,
    required this.idClass,
    super.key,
    required this.nameClass,
    required this.onTap,
    required this.nameCreator,
    required this.location,
    required this.deviceName,
    required this.attendanceTime,
  });

  @override
  ConsumerState<CardAttendance> createState() => _CardAttendanceState();
}

class _CardAttendanceState extends ConsumerState<CardAttendance> {
  String attendanceTime = '';
  String deviceName = '';
  String location = '';
  int remainingTime = 0;
  @override
  void initState() {
    super.initState();

    loadRemainingTime();
  }

  void loadRemainingTime() {
    DateTime now = DateTime.now();
    DateTime endTime;
    if (widget.secondsAttendance.isNotEmpty) {
      endTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(widget.secondsAttendance);
    } else {
      endTime = now;
    }

    Duration difference = endTime.difference(now);

    setState(() {
      remainingTime = difference.inSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 15.w,
          ),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        maxLines: 1,
                        widget.nameClass,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 17.sp,
                          color: AppTheme.nearlyBlack,
                        ),
                      ),
                      Text(
                        'Chủ nhóm ${widget.nameCreator}',
                        maxLines: 1,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          color: AppTheme.nearlyBlack,
                        ),
                      ),
                      if (widget.attendanceTime.isNotEmpty &&
                          widget.deviceName.isNotEmpty &&
                          widget.location.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Attendance time: ${widget.attendanceTime}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: AppTheme.nearlyBlack,
                              ),
                            ),
                            Text(
                              'Device name: ${widget.deviceName}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: AppTheme.nearlyBlack,
                              ),
                            ),
                            Text(
                              'Location: ${widget.location}',
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: AppTheme.nearlyBlack,
                              ),
                            ),
                          ],
                        ),
                      OutlinedButton(
                        onPressed: widget.onTap,
                        child: const Text('Điểm danh'),
                      )
                    ]),
              ),
              Column(
                children: [
                  SlideCountdown(
                    onChanged: (value) {},
                    separator: '',
                    onDone: () {},
                    icon: const Row(
                      children: [
                        Icon(Icons.lock_clock, color: AppTheme.nearlyWhite),
                        Gap(5)
                      ],
                    ),
                    decoration: const BoxDecoration(
                      color: AppTheme.nearlyBlue,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                        top: Radius.circular(10),
                      ),
                    ),
                    durationTitle: const DurationTitle(
                      minutes: ':',
                      days: ':',
                      hours: ':',
                      seconds: '',
                    ),
                    duration: Duration(seconds: remainingTime),
                    separatorType: SeparatorType.title,
                    slideDirection: SlideDirection.up,
                  ),
                  Gap(15.h),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();

                      Navigator.pushNamed(context, DisplayQrScreen.routeName,
                          arguments: {'data': widget.idClass});
                    },
                    child: SizedBox(
                      height: 70.h,
                      width: 70.w,
                      child: FittedBox(
                        child: QrImageView(
                          data: widget.idClass,
                          size: 200.w,
                          version: QrVersions.auto,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
