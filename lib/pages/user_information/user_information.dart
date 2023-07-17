import 'dart:io';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/common/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snack;
import 'package:attendance_/common/widgets/custom_button.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-information-screen';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  void storeUserData() {
    HapticFeedback.heavyImpact();
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    if (name.isNotEmpty || email.isNotEmpty) {
      ref.read(authControllerProvider.notifier).saveUserDataToFirebase(
            context: context,
            name: name,
            profilePic: image,
            email: email,
          );
    } else {
      showSnackBarCustom(context, snack.ContentType.warning, 'Lỗi rùi nè',
          'Ôi bạn ơi, bạn vui lòng nhập đầy đủ tên và email nha!!');
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
  }

  void selectImage() async {
    HapticFeedback.heavyImpact();
    final res = await pickImage();
    if (res != null) {
      setState(() {
        image = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: AnimationLimiter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 25.h, horizontal: 5.w),
                    child: Center(
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
                            InkWell(
                              onTap: () => selectImage(),
                              child: image == null
                                  ? CircleAvatar(
                                      backgroundColor: AppTheme.nearlyDarkBlue
                                          .withOpacity(0.9),
                                      radius: 50,
                                      child: const Icon(
                                        Icons.account_circle,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage: FileImage(image!),
                                      radius: 50,
                                    ),
                            ),
                            Container(
                              width: context.screenSize.width,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  TextFieldCustom2(
                                      hintText: "John Smith",
                                      icon: Icons.account_circle_rounded,
                                      inputType: TextInputType.name,
                                      controller: nameController,
                                      maxLines: 1),
                                  TextFieldCustom2(
                                      hintText: "abc@example.com",
                                      icon: Icons.email,
                                      inputType: TextInputType.emailAddress,
                                      controller: emailController,
                                      maxLines: 1),
                                  Gap(80.h),
                                  SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: SizedBox(
                                        height: 55,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.80,
                                        child: CustomButton(
                                          onPressed: () => storeUserData(),
                                          text: "Tiếp tục",
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (isLoading) const Loader2()
        ],
      ),
    );
  }
}
