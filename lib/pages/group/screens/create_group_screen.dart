import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snack;
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/pages/group/controller/group_controller.dart';
import 'package:attendance_/pages/group/widgets/select_contact_group.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-group';
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen>
    with WidgetsBindingObserver {
  final TextEditingController groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    HapticFeedback.heavyImpact();
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    HapticFeedback.heavyImpact();
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider.notifier).createGroup(
            context,
            groupNameController.text.trim(),
            image!,
            ref.read(selectedGroupContacts),
          );
      ref.read(selectedGroupContacts.notifier).update((state) => []);
      Navigator.pop(context);
    } else {
      showSnackBarCustom(
          context,
          snack.ContentType.warning,
          'Có một vấn đề nhỏ!',
          'Bạn vui lòng nhập tên nhóm và chọn ảnh đại diện của nhóm nhé!');
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();

    groupNameController.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider.notifier).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider.notifier).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(groupControllerProvider);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppTheme.darkerText,
        backgroundColor: AppTheme.background,
        title: TextWidget(
          text: 'Tạo nhóm trò chuyện mới',
          color: AppTheme.darkerText,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Gap(10),
                  Stack(
                    children: [
                      image == null
                          ? const CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png',
                              ),
                              radius: 64,
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(
                                image!,
                              ),
                              radius: 64,
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            CupertinoIcons.photo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      maxLength: 30,
                      style: AppTheme.body2,
                      controller: groupNameController,
                      decoration: const InputDecoration(
                        hintText: 'Nhập tên nhóm',
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'Chọn liên hệ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.nearlyDarkBlue.withOpacity(0.9),
                      ),
                    ),
                  ),
                  const SelectContactsGroup(),
                ],
              ),
            ),
          ),
          if (isLoading) const Loader2()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: AppTheme.nearlyDarkBlue.withOpacity(0.9),
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
