import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/qr_app/display_qr/display_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ItemClass extends ConsumerWidget {
  const ItemClass(
      {super.key,
      required this.nameClass,
      required this.quantityStudent,
      required this.idClass});
  final String nameClass;
  final int quantityStudent;
  final String idClass;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: 130.w,
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 32, left: 8, right: 8, bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: HexColor('#FFB295').withOpacity(0.6),
                      offset: const Offset(1.1, 4.0),
                      blurRadius: 8.0),
                ],
                gradient: LinearGradient(
                  colors: quantityStudent > 10
                      ? [
                          HexColor('#6F72CA'),
                          HexColor('#1E1466'),
                        ]
                      : quantityStudent < 10
                          ? [
                              HexColor('#FE95B6'),
                              HexColor('#FF5287'),
                            ]
                          : quantityStudent < 5
                              ? [
                                  HexColor('#738AE6'),
                                  HexColor('#5C5EDD'),
                                ]
                              : [
                                  HexColor('#FA7D82'),
                                  HexColor('#FFB295'),
                                ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(54.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 54, left: 16, right: 16, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      nameClass,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme.fontName,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        letterSpacing: 0.2,
                        color: AppTheme.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          overflow: TextOverflow.ellipsis,
                          quantityStudent.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 24.sp,
                            letterSpacing: 0.2,
                            color: AppTheme.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 3),
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            'học sinh',
                            style: TextStyle(
                              fontFamily: AppTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              letterSpacing: 0.2,
                              color: AppTheme.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: AppTheme.nearlyWhite.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 8,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.heavyImpact();
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRight,
                    child: DisplayQrScreen(data: idClass),
                  ),
                );
              },
              child: SizedBox(
                height: 60.h,
                width: 60.w,
                child: FittedBox(
                  child: QrImageView(
                    data: idClass,
                    size: 150.w,
                    version: QrVersions.auto,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
