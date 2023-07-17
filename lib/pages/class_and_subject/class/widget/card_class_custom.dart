import 'package:attendance_/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/class_and_subject/class/widget/widgets/wave_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CardClassCustom extends StatefulWidget {
  const CardClassCustom(
      {Key? key,
      required this.sumStudent,
      required this.className,
      required this.absent,
      required this.present})
      : super(key: key);
  final String className;
  final int present;
  final int absent;
  final int sumStudent;

  @override
  CardClassCustomState createState() => CardClassCustomState();
}

class CardClassCustomState extends State<CardClassCustom>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final percentageValue = (widget.present / widget.sumStudent) * 100;
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            topRight: Radius.circular(68.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: AppTheme.grey.withOpacity(0.1),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.className,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 25.sp,
                          color: AppTheme.nearlyDarkBlue,
                        ),
                      ),
                      Gap(20.h),
                      Text(
                        'Có mặt ${widget.present}',
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: AppTheme.nearlyDarkBlue,
                        ),
                      ),
                      Gap(10.h),
                      Text(
                        'Vắng  ${widget.absent}',
                        style: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: AppTheme.nearlyDarkBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 16.w, right: 26.w, top: 16.h, bottom: 16.h),
            child: Container(
              width: 60,
              height: 160,
              decoration: BoxDecoration(
                color: HexColor('#E8EDFE'),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(80.0),
                    bottomLeft: Radius.circular(80.0),
                    bottomRight: Radius.circular(80.0),
                    topRight: Radius.circular(80.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: AppTheme.grey.withOpacity(0.4),
                      offset: const Offset(2, 2),
                      blurRadius: 4),
                ],
              ),
              child: WaveView(
                percentageValue: percentageValue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
