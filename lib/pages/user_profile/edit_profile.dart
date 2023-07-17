import 'dart:io';

import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/constants.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:attendance_/common/widgets/textfield_custom.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/user_profile/controller/user_profile_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EditProfile extends ConsumerStatefulWidget {
  static const routeName = '/edit-profile';
  final String uid;
  const EditProfile({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  File? bannerFile;
  File? avatarFile;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController codeController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
    emailController =
        TextEditingController(text: ref.read(userProvider)!.email);
    codeController = TextEditingController(text: ref.read(userProvider)!.code);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectAvatarImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        avatarFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(
          context: context,
          profileFile: avatarFile,
          bannerFile: bannerFile,
          name: nameController.text.trim(),
          code: codeController.text.trim(),
          email: emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    return ref.watch(getUserDataByIdProvider(widget.uid)).when(
          data: (user) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: AppTheme.background,
                foregroundColor: AppTheme.darkText,
                title: TextWidget(
                  text: 'Chỉnh sửa thông tin cá nhân',
                  color: AppTheme.darkerText,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
                actions: [
                  TextButton(
                    onPressed: save,
                    child: const Text('Lưu'),
                  )
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 200,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: selectBannerImage,
                                    child: DottedBorder(
                                      borderType: BorderType.RRect,
                                      dashPattern: const [10, 4],
                                      strokeCap: StrokeCap.round,
                                      radius: Radius.circular(15.r),
                                      child: Container(
                                        height: 150,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.r)),
                                        child: bannerFile != null
                                            ? Image.file(bannerFile!)
                                            : user.banner.isEmpty ||
                                                    user.banner ==
                                                        ConstantsController
                                                            .bannerDefault
                                                ? const Center(
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: 45,
                                                    ),
                                                  )
                                                : Image.network(user.banner),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 15,
                                    left: 20,
                                    child: GestureDetector(
                                      onTap: selectAvatarImage,
                                      child: avatarFile != null
                                          ? CircleAvatar(
                                              radius: 35,
                                              backgroundImage:
                                                  FileImage(avatarFile!))
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                user.profilePic,
                                              ),
                                              radius: 35,
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Gap(7.h),
                            TextWidget(
                              text: 'Tên',
                              color: AppTheme.darkerText.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                              fontSize: 17.sp,
                            ),
                            TextFieldCustom2(
                                hintText: " Nhập tên của bạn..",
                                icon: Icons.account_circle_rounded,
                                inputType: TextInputType.name,
                                controller: nameController,
                                maxLines: 1),
                            Gap(7.h),
                            TextWidget(
                              text: 'Email',
                              color: AppTheme.darkerText.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                              fontSize: 17.sp,
                            ),
                            TextFieldCustom2(
                                hintText: " Nhập email của bạn..",
                                icon: Icons.email_rounded,
                                inputType: TextInputType.emailAddress,
                                controller: emailController,
                                maxLines: 1),
                            Gap(7.h),
                            TextWidget(
                              text: 'Code',
                              color: AppTheme.darkerText.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                              fontSize: 17.sp,
                            ),
                            TextFieldCustom2(
                                hintText: "Nhập mã code..",
                                icon: Icons.analytics_outlined,
                                inputType: TextInputType.number,
                                controller: codeController,
                                maxLines: 1),
                          ],
                        ),
                      ),
                    ),
            );
          },
          error: (error, stackTrace) => ErrorText(text: error.toString()),
          loading: () => const LoadingPage(),
        );
  }
}
