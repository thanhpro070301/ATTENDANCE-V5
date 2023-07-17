import 'package:attendance_/pages/qr_app/display_qr/display_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CardLesson extends StatelessWidget {
  final String nameLesson;
  final String idLesson;
  final int present;
  final String endAttendance;
  const CardLesson({
    required this.nameLesson,
    required this.idLesson,
    required this.endAttendance,
    required this.present,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displaySeconds = '0s';
    if (endAttendance.isNotEmpty) {
      DateTime endTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(endAttendance);
      Duration difference = endTime.difference(DateTime.now());
      displaySeconds =
          (difference.inSeconds >= 0) ? '${difference.inSeconds}s' : '0s';
    }
    return Padding(
      padding:
          EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h, bottom: 18.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 16.h, left: 16.w, right: 5.w, bottom: 10.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.only(left: 4.w, bottom: 8.h, top: 16.h),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Text(
                            nameLesson,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 25.sp,
                              color: AppTheme.nearlyDarkBlue,
                            ),
                          ),
                        ),
                      ),
                      Gap(5.h),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                color: AppTheme.grey.withOpacity(0.5),
                                size: 15.r,
                              ),
                              Gap(4.w),
                              if (displaySeconds.isNotEmpty)
                                Text(
                                  'Thời gian $displaySeconds',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    letterSpacing: 0.0,
                                    color: AppTheme.grey.withOpacity(0.5),
                                  ),
                                ),
                            ],
                          ),
                          Gap(5.h),
                          Text(
                            'Đã điểm danh $present',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              letterSpacing: 0.0,
                              color: AppTheme.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                Navigator.pushNamed(context, DisplayQrScreen.routeName,
                    arguments: {'data': idLesson});
              },
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 150, maxWidth: 150),
                child: SizedBox(
                  height: 60.w,
                  width: 60.w,
                  child: FittedBox(
                    child: RepaintBoundary(
                      child: QrImageView(
                        data: idLesson,
                        size: 200,
                        version: QrVersions.auto,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Gap(2.w),
          ],
        ),
      ),
    );
  }
}
