// ignore_for_file: use_build_context_synchronously

import 'package:attendance_/web/page/auth/verification_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'package:attendance_/common/widgets/custom_button.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/welcome-web';
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
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/image1.png", height: 300),
              const Gap(30),
              Text(
                "Hãy bắt đầu ngay",
                style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
              ),
              const Gap(30),
              const Text(
                textAlign: TextAlign.center,
                "Chào mừng bạn đến với ứng dụng điểm danh\n hãy điểm danh và khám phá ngày mới.",
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: CustomButton(
                    text: "Bắt đầu",
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginWeb.routeName,
                          (route) => false,
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
