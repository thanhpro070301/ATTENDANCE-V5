import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:quickalert/quickalert.dart';

import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/common/widgets/custom_button.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';

final lastPhoneProvider = StateProvider.autoDispose<String?>((ref) => null);
final phoneControllerProvider = StateProvider((ref) => TextEditingController());

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  void sendPhoneNumber() {
    HapticFeedback.heavyImpact();
    FocusManager.instance.primaryFocus?.unfocus();
    final authProvider = ref.watch(authControllerProvider.notifier);
    String phoneNumber = ref.watch(phoneControllerProvider).text.trim();
    if (phoneNumber.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Lỗi...',
        confirmBtnText: 'Đồng ý',
        confirmBtnColor: AppTheme.nearlyDarkBlue,
        text: 'Số điện thoại không được để trống',
      );

      return;
    }

    ref.read(userProvider.notifier).state = null;
    ref.read(lastPhoneProvider.notifier).state =
        "+${selectedCountry.phoneCode}$phoneNumber";
    authProvider.signInWithPhone(
        context, "+${selectedCountry.phoneCode}$phoneNumber");
  }

  void selectCountry() {
    HapticFeedback.heavyImpact();
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: 550,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      onSelect: (value) => setState(
        () {
          selectedCountry = value;
        },
      ),
    );
  }

  Country selectedCountry = Country(
    phoneCode: "84",
    countryCode: "VN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Vietnam",
    example: "Vietnam",
    displayName: "Vietnam",
    displayNameNoCountryCode: "VN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    ref.watch(phoneControllerProvider).selection = TextSelection.fromPosition(
        TextPosition(offset: ref.watch(phoneControllerProvider).text.length));
    final isLoading = ref.watch(isLoadingLoginProvider);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: AnimationLimiter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 35.w, vertical: 50.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 375),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          Container(
                            width: 200.w,
                            height: 200.h,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: AppTheme.nearlyDarkBlue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset("assets/image2.png"),
                          ),
                          Gap(20.h),
                          Text(
                            textAlign: TextAlign.center,
                            "Khởi đầu ngày mới bằng cách điểm danh.",
                            style: TextStyle(
                                fontSize: 22.sp, fontWeight: FontWeight.bold),
                          ),
                          Gap(20.h),
                          Text(
                            "Nhập số điện thoại của bạn. Chúng tôi sẽ gửi cho bạn một mã xác minh.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(20.h),
                          TextFormField(
                            controller: ref.watch(phoneControllerProvider),
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkText),
                            keyboardType: TextInputType.phone,
                            cursorColor:
                                AppTheme.nearlyDarkBlue.withOpacity(0.5),
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp,
                                  color: Colors.grey.shade600),
                              hintText: "Nhập số điện thoại của bạn.",
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide:
                                    const BorderSide(color: Colors.black12),
                              ),
                              prefixIcon: Container(
                                padding: EdgeInsets.all(12.w),
                                child: InkWell(
                                  onTap: selectCountry,
                                  child: Text(
                                    "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              suffixIcon: ref
                                          .watch(phoneControllerProvider)
                                          .text
                                          .length >
                                      8
                                  ? Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: Container(
                                        height: 15.h,
                                        width: 15.w,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green),
                                        child: Icon(
                                          CupertinoIcons.chevron_down_circle,
                                          color: Colors.white,
                                          size: 20.r,
                                        ),
                                      ),
                                    )
                                  : null,
                              filled: true,
                            ),
                          ),
                          Gap(20.h),
                          SizedBox(
                            width: double.infinity,
                            height: 55.h,
                            child: CustomButton(
                              text: "Xác nhận",
                              onPressed: sendPhoneNumber,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isLoading)
            const Align(
              alignment: Alignment.center,
              child: Loader(),
            )
        ],
      ),
    );
  }
}
