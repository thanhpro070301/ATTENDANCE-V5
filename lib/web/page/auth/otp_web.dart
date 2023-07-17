import 'package:attendance_/common/utils.dart';
import 'package:attendance_/web/page/auth/verification_confirmation.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:attendance_/common/values/theme.dart';

import 'package:attendance_/common/widgets/custom_button.dart';
import 'package:timer_button_fork/timer_button_fork.dart';

import 'controller/auth_controller.dart';

final pinControllerProvider =
    StateProvider.autoDispose((ref) => TextEditingController());

class OTPWeb extends ConsumerStatefulWidget {
  static const routeName = '/otp-web';
  final String verificationId;
  const OTPWeb({super.key, required this.verificationId});

  @override
  ConsumerState<OTPWeb> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPWeb> {
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
    final String OTP = ref.read(pinControllerProvider).text.trim();
    debugPrint('Your OTP $OTP');

    if (OTP != '' || OTP.length == 6) {
      verify(context, OTP, ref);
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Xác minh số điện thoại",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Nhập OTP đã gửi đến số điện thoại của bạn.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
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
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            verify(context, pin, ref);
                          },
                          closeKeyboardWhenCompleted: true,
                          textInputAction: TextInputAction.next,
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: AppTheme.focusedBorderColor,
                              ),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppTheme.focusedBorderColor),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              color: AppTheme.fillColor,
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(
                                  color: AppTheme.focusedBorderColor),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: CustomButton(
                          text: "Xác minh",
                          onPressed: () {
                            if (ref.read(pinControllerProvider).text.length ==
                                6) {
                              verify(
                                  context,
                                  ref.read(pinControllerProvider).text.trim(),
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
                      const SizedBox(height: 20),
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
                          final phone = ref.read(lastPhoneProvider);
                          authProvider.signInWithPhone(context, phone!.trim());
                        },
                        disabledColor:
                            AppTheme.dismissibleBackground.withOpacity(0.4),
                        color: AppTheme.nearlyDarkBlue.withOpacity(0.8),
                        disabledTextStyle:
                            TextStyle(fontSize: 15.sp, color: Colors.white),
                        activeTextStyle:
                            TextStyle(fontSize: 15.sp, color: Colors.white),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
