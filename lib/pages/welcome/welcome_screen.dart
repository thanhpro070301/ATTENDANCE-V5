// ignore_for_file: use_build_context_synchronously

import 'package:attendance_/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:attendance_/common/widgets/custom_button.dart';
import 'package:attendance_/pages/auth/verification_confirmation.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/welcome-screen';
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 35.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/image1.png",
                  height: context.screenSize.height / 3),
              Gap(30.h),
              Text(
                "Hãy bắt đầu ngay",
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
              ),
              Gap(30.h),
              Text(
                textAlign: TextAlign.center,
                "Chào mừng bạn đến với ứng dụng điểm danh\n hãy điểm danh và khám phá ngày mới.",
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold),
              ),
              Gap(15.h),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: CustomButton(
                    text: "Bắt đầu",
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginScreen.routeName,
                        (route) => false,
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
