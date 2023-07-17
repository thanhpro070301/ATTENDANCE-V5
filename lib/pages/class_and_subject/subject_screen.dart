import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/class_and_subject/class/widget/card_subject.dart';
import 'package:attendance_/pages/lesson_class/controller/lesson_controller.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';

import 'package:attendance_/models/subjects_model/subject_model.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/details_subject_and_class/details_subject_and_class.dart';
import 'dart:math' as math;
import 'package:attendance_/common/widgets/clock.dart';
import 'package:attendance_/common/widgets/textfield_custom.dart';
import 'package:attendance_/pages/class_and_subject/subject/controller/subject_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:page_transition/page_transition.dart';

class Subject extends ConsumerStatefulWidget {
  static const routeName = "/subject";
  const Subject({super.key});

  @override
  ConsumerState<Subject> createState() => _SubjectState();
}

class _SubjectState extends ConsumerState<Subject> with WidgetsBindingObserver {
  final nameSubjectController = TextEditingController();
  var nameEditClassController = TextEditingController();

  @override
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
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
    final uid = ref.watch(userProvider)!.uid;
    String dateNow = formatDate(DateTime.now());
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: AppTheme.darkerText,
        backgroundColor: AppTheme.background,
        title: TextWidget(
          text: 'Danh sách chủ đề',
          color: AppTheme.darkerText,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
      ),
      body: Column(
        children: [
          const Gap(10),
          const ClockWidget(),
          Expanded(
            child: ref.watch(getSubjectProvider(uid)).when(
                  data: (data) {
                    if (data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: context.screenSize.width / 3.5,
                                height: context.screenSize.height / 8,
                                child: FittedBox(
                                  child: Image.asset('assets/document.png',
                                      fit: BoxFit.cover,
                                      color: AppTheme.darkText),
                                )),
                            Padding(
                              padding: EdgeInsets.all(8.w),
                              child: SizedBox(
                                width: context.screenSize.width,
                                height: 40.h,
                                child: FittedBox(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    'Bạn không có chủ đề nào cả, thử tạo 1 chủ đề, trải nghiệm ngay nào!',
                                    style: AppTheme.body2.copyWith(
                                        color: AppTheme.darkText,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return AnimationLimiter(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final subject = data[index];
                          final int counter = math.Random().nextInt(100);
                          Color color = Colors.transparent;

                          switch (counter % 6) {
                            case 1:
                              color = Colors.blue;
                              break;
                            case 2:
                              color = Colors.purple;
                              break;
                            case 3:
                              color = Colors.yellow;
                              break;
                            case 4:
                              color = Colors.green;
                              break;
                            case 5:
                              color = Colors.orange;
                              break;
                            case 6:
                              color = Colors.lightBlue;
                              break;
                            case 7:
                              color = Colors.pink;
                              break;
                            case 8:
                              color = Colors.cyan;
                              break;

                            case 9:
                              color = Colors.tealAccent;
                              break;
                            case 0:
                              color = Colors.red;
                              break;
                            default:
                              color = Colors.transparent;
                          }
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();

                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.scale,
                                        alignment: Alignment.topCenter,
                                        duration:
                                            const Duration(milliseconds: 400),
                                        isIos: true,
                                        child: DetailsClassScreen(
                                          idSubject: subject.id,
                                          nameSubject: subject.nameSubject,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          onPressed: (context) {
                                            ref
                                                .read(lessonControllerProvider
                                                    .notifier)
                                                .deleteSubjectById(subject.id);
                                          },
                                          backgroundColor:
                                              const Color(0xFFFE95B6),
                                          foregroundColor: AppTheme.nearlyWhite,
                                          icon: Icons.delete,
                                          label: 'Xóa',
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(4.w),
                                      child: CardTodoListWidget(
                                        onPressed: () => {
                                          HapticFeedback.heavyImpact(),
                                          nameEditClassController =
                                              TextEditingController(
                                                  text: subject.nameSubject),
                                          showDialogCustom(
                                            controller: nameEditClassController,
                                            context: context,
                                            hintText: 'Nhập tên chủ đề',
                                            title: 'Chỉnh sửa chủ đề',
                                            onTap: () {
                                              HapticFeedback.heavyImpact();
                                              ref
                                                  .read(
                                                      subjectControllerProvider
                                                          .notifier)
                                                  .updateSubject(
                                                      context: context,
                                                      subjectModel: SubjectModel(
                                                          listUserPhone: [],
                                                          createdAt:
                                                              subject.createdAt,
                                                          updatedAt: dateNow,
                                                          uid: ref
                                                              .watch(
                                                                  userProvider)!
                                                              .uid,
                                                          id: subject.id,
                                                          lessons: [],
                                                          nameSubject:
                                                              nameEditClassController
                                                                  .text,
                                                          nameTeacher: subject
                                                              .nameTeacher),
                                                      id: subject.id);
                                              nameEditClassController.clear();
                                            },
                                          )
                                        },
                                        isShowEdit: true,
                                        title: subject.nameSubject,
                                        description:
                                            'Số buổi ${subject.lessons.length}',
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    text: error.toString(),
                  ),
                  loading: () => const Loader(),
                ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.nearlyDarkBlue.withOpacity(0.9),
          onPressed: () async {
            HapticFeedback.heavyImpact();
            showDialogCustom(
              context: context,
              hintText: 'Nhập tên chủ đề',
              title: 'Tạo chủ đề',
              controller: nameSubjectController,
              onTap: () {
                HapticFeedback.heavyImpact();
                if (nameSubjectController.text.isEmpty) {
                  showSnackBarCustom(context, ContentType.warning,
                      'Có một lỗi nhỏ', 'Vui lòng nhập tên chủ đề!');
                  return;
                }
                ref
                    .read(subjectControllerProvider.notifier)
                    .createSubject(context, nameSubjectController.text);
                nameSubjectController.clear();
                Navigator.pop(context);
              },
            );
          },
          child: const Icon(CupertinoIcons.add)),
    );
  }
}

void showDialogCustom(
    {required BuildContext context,
    required String hintText,
    required VoidCallback onTap,
    required TextEditingController controller,
    required String title}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFieldCustom(
              controller: controller,
              hintText: hintText,
              keyboardType: TextInputType.text),
        ]),
        actions: [
          TextButton(
            child: const Text('Hủy bỏ'),
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: onTap,
            child: const Text('Lưu'),
          )
        ],
      );
    },
  );
}
