import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/pages/auth/verification_confirmation.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:attendance_/common/values/theme.dart';

import 'package:attendance_/common/widgets/custom_button.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:timer_button_fork/timer_button_fork.dart';

final pinControllerProvider =
    StateProvider.autoDispose((ref) => TextEditingController());

class OTPScreen extends ConsumerStatefulWidget {
  static const routeName = '/otp-screen';
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final focusNode = FocusNode();
  void verify(BuildContext context, String userOTP, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).verify(
          context: context,
          userOTP: userOTP,
          verificationId: widget.verificationId,
        );
  }

  @override
  void initState() {
    super.initState();
    final String otpPhone = ref.read(pinControllerProvider).text.trim();
    debugPrint('Your otpPhone $otpPhone');

    if (otpPhone != '' || otpPhone.length == 6) {
      verify(context, otpPhone, ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppTheme.borderColor),
      ),
    );
    final authProvider = ref.watch(authControllerProvider.notifier);
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: isLoading
          ? const PreferredSize(
              preferredSize: Size(0, 0),
              child: SizedBox(),
            )
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: AppTheme.nearlyBlack,
            ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: AnimationLimiter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 35.w, vertical: 25.h),
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
                          Gap(20.h),
                          const Text(
                            "Xác minh số điện thoại",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const Gap(20),
                          Text(
                            "Nhập OTP đã gửi đến số điện thoại của bạn.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.bold),
                          ),
                          Gap(20.h),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Pinput(
                              length: 6,
                              controller: ref.watch(pinControllerProvider),
                              focusNode: focusNode,
                              androidSmsAutofillMethod:
                                  AndroidSmsAutofillMethod.none,
                              listenForMultipleSmsOnAndroid: true,
                              defaultPinTheme: defaultPinTheme,
                              keyboardType: TextInputType.number,
                              hapticFeedbackType:
                                  HapticFeedbackType.lightImpact,
                              onCompleted: (pin) {
                                verify(context, pin, ref);
                              },
                              closeKeyboardWhenCompleted: true,
                              textInputAction: TextInputAction.next,
                              cursor: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 9.h),
                                    width: 22.w,
                                    height: 1.w,
                                    color: AppTheme.focusedBorderColor,
                                  ),
                                ],
                              ),
                              focusedPinTheme: defaultPinTheme.copyWith(
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                      color: AppTheme.focusedBorderColor),
                                ),
                              ),
                              submittedPinTheme: defaultPinTheme.copyWith(
                                decoration:
                                    defaultPinTheme.decoration!.copyWith(
                                  color: AppTheme.fillColor,
                                  borderRadius: BorderRadius.circular(19.r),
                                  border: Border.all(
                                      color: AppTheme.focusedBorderColor),
                                ),
                              ),
                              errorPinTheme: defaultPinTheme.copyBorderWith(
                                border: Border.all(color: Colors.redAccent),
                              ),
                            ),
                          ),
                          Gap(20.h),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: CustomButton(
                              text: "Xác minh",
                              onPressed: () {
                                HapticFeedback.heavyImpact();
                                if (ref
                                        .read(pinControllerProvider)
                                        .text
                                        .length ==
                                    6) {
                                  verify(
                                      context,
                                      ref
                                          .read(pinControllerProvider)
                                          .text
                                          .trim(),
                                      ref);
                                } else {
                                  showSnackBarCustom(
                                      context,
                                      ContentType.failure,
                                      'Lỗi!',
                                      'Vui lòng nhập mã xác minh đủ 6 kí tự !');
                                }
                              },
                            ),
                          ),
                          Gap(20.h),
                          const Text(
                            "Bạn không nhận được bất kỳ mã nào?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const Gap(20),
                          TimerButton(
                            buttonType: ButtonType.TextButton,
                            label: "Gửi lại mã xác thực",
                            timeOutInSeconds: 60,
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              final phone = ref.read(lastPhoneProvider);
                              authProvider.signInWithPhone(
                                  context, phone!.trim());
                            },
                            disabledColor:
                                AppTheme.dismissibleBackground.withOpacity(0.4),
                            color: AppTheme.nearlyDarkBlue.withOpacity(0.8),
                            disabledTextStyle:
                                TextStyle(fontSize: 15.sp, color: Colors.white),
                            activeTextStyle:
                                TextStyle(fontSize: 15.sp, color: Colors.white),
                          ),
                          Gap(20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isLoading) const Loader()
        ],
      ),
    );
  }
}
