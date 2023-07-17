import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/path_provider.dart';
import 'package:attendance_/common/values/save_read_excel.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'dart:developer' as developer;
import 'package:attendance_/common/values/theme.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snack;
import 'package:attendance_/pages/class_and_subject/class/controller/class_controller.dart';
import 'package:attendance_/pages/lesson_class/controller/lesson_controller.dart';
import 'package:attendance_/pages/lesson_class/provider/lesson_provider.dart';
import 'package:attendance_/common/widgets/choose_datetime_button.dart';
import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:attendance_/common/widgets/textfield_custom.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/quickalert.dart';
import 'package:uuid/uuid.dart';

class CreateLessonScreen extends ConsumerStatefulWidget {
  static const routeName = '/create-lesson-screen';
  final String nameSubject;
  final String idSubject;
  const CreateLessonScreen(
      {super.key, required this.nameSubject, required this.idSubject});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateLessonScreenState();
}

class _CreateLessonScreenState extends ConsumerState<CreateLessonScreen>
    with WidgetsBindingObserver {
  final classRoomController = TextEditingController();
  final classNameController = TextEditingController();
  final locationController = TextEditingController();
  final listUserController = TextEditingController();

  List<String> userList = [];

  late String selectedClass;

  @override
  void initState() {
    super.initState();
    getPublicDirectoryPath(ref);
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
  void dispose() {
    super.dispose();
    classRoomController.dispose();
    classNameController.dispose();
    locationController.dispose();
    listUserController.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  void createClassOrLesson() {
    HapticFeedback.heavyImpact();
    FocusManager.instance.primaryFocus?.unfocus();

    if (widget.nameSubject.isNotEmpty) {
      if (classRoomController.text.isEmpty || locationController.text.isEmpty) {
        showSnackBarCustom(context, snack.ContentType.warning,
            'Có một vấn đề nhỏ!', 'Bạn ơi, Vui lòng nhập đầy đủ nha!!');
        return;
      } else {
        ref.read(lessonControllerProvider.notifier).createLesson(
              context: context,
              nameSubject: widget.nameSubject,
              idSubject: widget.idSubject,
              location: locationController.text,
              roomName: classRoomController.text,
            );
      }
    } else {
      if (classNameController.text.isEmpty) {
        showSnackBarCustom(context, snack.ContentType.warning,
            'Có một vấn đề nhỏ!', 'Bạn ơi, Vui lòng nhập tên nhóm!!');
        return;
      } else if (listUserController.text.isEmpty) {
        showSnackBarCustom(
            context,
            snack.ContentType.warning,
            'Có một vấn đề nhỏ!',
            'Bạn ơi, Vui lòng nhập tối thiểu 1 số điện thoại thuộc nhóm này!!');
        return;
      } else if (listUserController.text.length < 9) {
        showSnackBarCustom(
            context,
            snack.ContentType.warning,
            'Có một vấn đề nhỏ!',
            'Bạn ơi, Vui lòng nhập số điện thoại hợp lệ!');
        return;
      } else {
        Set<String> userSet = {};
        String input = listUserController.text.trim();
        List<String> userIDs = input.split(",").map((id) => id.trim()).toList();
        userSet.addAll(userIDs);
        List<String> userList = userSet.toList();
        List<String> formattedUserList = userList.map((phoneNumber) {
          if (phoneNumber.startsWith("0")) {
            return "+84${phoneNumber.substring(1)}";
          } else {
            return phoneNumber;
          }
        }).toList();
        listUserController.clear();
        developer.log(userList.toString());
        final idClass = const Uuid().v4();
        ref.read(classControllerProvider.notifier).createClass(context,
            classNameController.text.trim(), formattedUserList, idClass);
      }
    }
  }

  void pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );

    if (date != null) {
      ref.watch(selectedDateProvider.notifier).update((state) => date);
    }
  }

  void pickTimeStart() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      ref.watch(selectedTimeStartProvider.notifier).update((state) => time);
    }
  }

  void pickTimeEnd() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      ref.watch(selectedTimeEndProvider.notifier).update((state) => time);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoadingForLesson = ref.watch(lessonControllerProvider);
    final isLoadingForClass = ref.watch(classControllerProvider);
    final isLoading =
        widget.idSubject.isNotEmpty ? isLoadingForLesson : isLoadingForClass;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        actions: [
          if (widget.idSubject.isEmpty)
            IconButton(
              icon: const Icon(Icons.thermostat_auto_sharp),
              onPressed: () async {
                final permission = await getPublicDirectoryPath(ref);
                if (permission) {
                  if (context.mounted) {
                    ref
                        .read(authControllerProvider.notifier)
                        .getStudents(context);
                    await Future.delayed(const Duration(seconds: 2), () async {
                      await createExcelFileTest(context, ref, '1');
                    });
                  }
                } else {
                  getPublicDirectoryPath(ref);
                }
              },
            )
        ],
        foregroundColor: AppTheme.darkerText,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();

            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.pop(context);
            });
          },
        ),
        backgroundColor: AppTheme.background,
        title: TextWidget(
          text: widget.nameSubject.isNotEmpty
              ? 'Tạo buổi học mới'
              : 'Tạo một nhóm mới',
          color: AppTheme.darkerText,
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: AnimationLimiter(
              child: Padding(
                padding: EdgeInsets.all(15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      TextWidget(
                        text: widget.nameSubject.isNotEmpty
                            ? 'Nhập tên phòng học'
                            : ' Nhập tên nhóm học',
                        color: AppTheme.darkerText.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                      ),
                      TextFieldCustom(
                        keyboardType: TextInputType.text,
                        controller: widget.nameSubject.isNotEmpty
                            ? classRoomController
                            : classNameController,
                        hintText: widget.nameSubject.isNotEmpty
                            ? "Ví dụ: F7.5"
                            : "Ví dụ: CDTH20A",
                      ),
                      Gap(20.h),
                      if (widget.nameSubject.isNotEmpty)
                        TextWidget(
                          text: 'Địa chỉ',
                          color: AppTheme.darkerText.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
                      if (widget.nameSubject.isNotEmpty)
                        TextFieldCustom(
                          keyboardType: TextInputType.streetAddress,
                          controller: locationController,
                          hintText: "Ví dụ: HCM Q5",
                        ),
                      if (widget.nameSubject.isEmpty)
                        TextWidget(
                          text: 'Nhập các số điện thoại thuộc nhóm này.',
                          color: AppTheme.darkerText.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
                      if (widget.nameSubject.isEmpty)
                        TextWidget(
                          text: 'Cách nhau bởi 1 dấu phẩy.',
                          color: AppTheme.darkerText.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
                      if (widget.nameSubject.isEmpty)
                        TextWidget(
                          text: 'Hoặc nhập từ danh sách trong file Excel.',
                          color: AppTheme.darkerText.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp,
                        ),
                      if (widget.nameSubject.isEmpty) Gap(5.h),
                      if (widget.nameSubject.isEmpty)
                        TextFieldCustom(
                          isWriteListPhone: true,
                          keyboardType: TextInputType.phone,
                          controller: listUserController,
                          hintText: "033.., 033259,024..",
                          onPressed: () async {
                            final permission =
                                await getPublicDirectoryPath(ref);
                            if (permission) {
                              if (context.mounted) {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.confirm,
                                    title: 'Nhập số điện thoại từ Excel',
                                    confirmBtnText: 'Có',
                                    cancelBtnText: 'Không',
                                    text:
                                        'Bạn có muốn nhập số điện thoại từ Excel không?!',
                                    onCancelBtnTap: () =>
                                        Navigator.pop(context),
                                    onConfirmBtnTap: () async {
                                      Navigator.pop(context);
                                      await readExcelFile(ref)
                                          .then((value) => getPhoneOfExcel())
                                          .then(
                                            (value) => listUserController
                                                .setText(value.join(', ')),
                                          );
                                    });
                              }
                            } else {
                              if (context.mounted) {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.confirm,
                                    title: 'Có 1 vấn đề nhỏ',
                                    confirmBtnText: 'Có',
                                    cancelBtnText: 'Không',
                                    text:
                                        'Bạn chưa cấp quyền truy cập bộ nhớ cho ứng dụng, bạn muốn cập nhật ngay không?!',
                                    onCancelBtnTap: () =>
                                        Navigator.pop(context),
                                    onConfirmBtnTap: () {
                                      Navigator.pop(context);
                                      openAppSettings(ref);
                                    });
                              }
                            }
                          },
                        ),
                      Gap(20.h),
                      Align(
                        alignment: Alignment.center,
                        child: ChooseDateButton(
                            text: widget.nameSubject.isEmpty
                                ? "Tạo nhóm mới"
                                : "Tạo buổi học mới",
                            voidCallback: createClassOrLesson),
                      )
                    ],
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
