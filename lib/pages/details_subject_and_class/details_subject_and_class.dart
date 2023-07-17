import 'dart:io';
import 'package:attendance_/common/values/save_read_excel.dart';
import 'package:attendance_/models/subjects_model/subject_model.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snack;
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/path_provider.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/class_and_subject/class/widget/widgets/card_lesson.dart';
import 'package:attendance_/pages/class_and_subject/class/widget/card_class_custom.dart';
import 'package:attendance_/pages/user_profile/user_profile.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:gap/gap.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/attendance/attendance.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/class_and_subject/class/controller/class_controller.dart';
import 'package:attendance_/pages/class_and_subject/subject/controller/subject_controller.dart';
import 'package:attendance_/pages/lesson_class/controller/lesson_controller.dart';
import 'package:attendance_/pages/lesson_class/create_lesson_class_screen.dart';
import 'package:attendance_/common/widgets/text_widget.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:developer' as developer;

class DetailsClassScreen extends ConsumerStatefulWidget {
  static const routeName = "/details-class-screen";
  final String nameSubject;
  final String idSubject;
  const DetailsClassScreen({
    super.key,
    required this.nameSubject,
    required this.idSubject,
  });

  @override
  ConsumerState<DetailsClassScreen> createState() => _DetailsClassScreenState();
}

class _DetailsClassScreenState extends ConsumerState<DetailsClassScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  AnimationController? animationController;
  bool showFloatingActionButton = false;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(vsync: this, length: myTabs.length);
    _handleTabSelection();
  }

  static List<Tab> myTabs = <Tab>[
    const Tab(
      text: "Buổi học",
    ),
    const Tab(
      text: 'Thống kê',
    ),
  ];
  void _handleTabSelection() {
    HapticFeedback.heavyImpact();
    setState(() {
      showFloatingActionButton = _tabController.index == 0;
    });
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

  void navigateToUserProfile(String uid) {
    Navigator.push(
      context,
      PageTransition(
        curve: Curves.bounceOut,
        type: PageTransitionType.leftToRight,
        alignment: Alignment.topCenter,
        child: UserProfile(
          uid: uid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppTheme.darkText,
        title: TextWidget(
          text: widget.nameSubject.isEmpty
              ? "Danh sách nhóm"
              : widget.nameSubject,
          color: AppTheme.darkerText,
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
        ),
      ),
      body: TabBarView(
          physics: const BouncingScrollPhysics(),
          controller: _tabController,
          children: [
            _lessonsWidget(ref, user),
            _statisticalWidget(widget.idSubject),
          ]),
      floatingActionButton:
          widget.idSubject.isNotEmpty || widget.nameSubject.isNotEmpty
              ? showFloatingActionButton
                  ? FloatingActionButton.extended(
                      icon: const Icon(CupertinoIcons.add),
                      label: Text(
                        'Tạo buổi học',
                        style: AppTheme.body2.copyWith(
                            fontSize: 17.sp,
                            color: AppTheme.background,
                            fontWeight: FontWeight.w500),
                      ),
                      backgroundColor: AppTheme.nearlyDarkBlue.withOpacity(0.9),
                      elevation: 0,
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: CreateLessonScreen(
                                idSubject: widget.idSubject,
                                nameSubject: widget.nameSubject),
                          ),
                        );
                      },
                    )
                  : null
              : FloatingActionButton.extended(
                  icon: const Icon(CupertinoIcons.add),
                  label: Text(
                    'Tạo nhóm mới',
                    style: AppTheme.body2.copyWith(
                        fontSize: 17.sp,
                        color: AppTheme.background,
                        fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: AppTheme.nearlyDarkBlue.withOpacity(0.9),
                  elevation: 0,
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    Navigator.pushNamed(context, CreateLessonScreen.routeName,
                        arguments: {
                          'nameSubject': '',
                          'idSubject': '',
                        });
                  },
                ),
      bottomNavigationBar: widget.idSubject.isNotEmpty ? _tabBar() : null,
    );
  }

  Widget _statisticalWidget(String idSubject) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(children: [
          ref.watch(getSubjectByIdProvider(idSubject)).when(
                data: (data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Tổng số buổi học: ${data!.lessons.length}',
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: AppTheme.darkText,
                      ),
                      Gap(15.h),
                      Column(
                        children: [
                          TextWidget(
                            text: 'Danh sách các học viên đã điểm',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: AppTheme.darkText,
                          ),
                          TextWidget(
                            text: 'danh vào môn này và số lượng',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            color: AppTheme.darkText,
                          ),
                        ],
                      ),
                      Gap(15.h),
                      _exportExcelStatistical(idSubject, data),
                      Gap(25.h),
                      ref
                          .watch(getAttendanceByLessonUseIdSubjectProvider(
                              idSubject))
                          .when(
                            data: (dataAttendance) {
                              Map<String, int> presentCountMap = {};
                              for (var attendance in dataAttendance) {
                                if (attendance.statusAttendance == 'present') {
                                  if (presentCountMap
                                      .containsKey(attendance.nameStudent)) {
                                    presentCountMap[attendance.nameStudent] =
                                        presentCountMap[
                                                attendance.nameStudent]! +
                                            1;
                                  } else {
                                    presentCountMap[attendance.nameStudent] = 1;
                                  }
                                }
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: presentCountMap.length,
                                itemBuilder: (context, index) {
                                  final count =
                                      presentCountMap.values.elementAt(index);
                                  final dataStudent = dataAttendance[index];
                                  return Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20.r),
                                        bottomRight: Radius.circular(20.r),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              ref
                                                  .watch(
                                                      getUserDataByIdProvider(
                                                          dataStudent
                                                              .idStudent))
                                                  .when(
                                                    data: (userOfLesson) =>
                                                        GestureDetector(
                                                      onTap: () =>
                                                          navigateToUserProfile(
                                                              userOfLesson.uid),
                                                      child: CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                userOfLesson
                                                                    .profilePic),
                                                      ),
                                                    ),
                                                    error: (error,
                                                            stackTrace) =>
                                                        ErrorText(
                                                            text: error
                                                                .toString()),
                                                    loading: () =>
                                                        const Loader2(),
                                                  ),
                                              Gap(7.w),
                                              SizedBox(
                                                width:
                                                    context.screenSize.width /
                                                        4,
                                                child: Text(
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  dataStudent.nameStudent,
                                                  style: AppTheme.body2
                                                      .copyWith(
                                                          fontSize: 15.sp),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Gap(5.w),
                                          Text(
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            ' Có mặt $count, ${data.lessons.length - count} vắng',
                                            style: AppTheme.caption.copyWith(
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(text: error.toString()),
                            loading: () => const Loader(),
                          ),
                    ],
                  );
                },
                error: (error, stackTrace) => ErrorText(text: error.toString()),
                loading: () => const Loader(),
              ),
        ]),
      ),
    );
  }

  OutlinedButton _exportExcelStatistical(String idSubject, SubjectModel data) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(fixedSize: Size(130.w, 7.h)),
      icon: Icon(
        Icons.addchart_sharp,
        size: 25.r,
      ),
      label: const TextWidget(
        color: AppTheme.darkText,
        text: 'Xuất Excel',
        fontWeight: FontWeight.w500,
      ),
      onPressed: () async {
        Set<Map<String, int>> statisticalList = {};
        ref.read(getAttendanceByLessonUseIdSubjectProvider(idSubject)).when(
              data: (dataAttendance) async {
                for (var attendance in dataAttendance) {
                  if (attendance.statusAttendance == 'present') {
                    Map<String, int> presentCountMap = {
                      attendance.nameStudent: 1
                    };

                    bool isStatisticalExist = false;
                    for (var statistical in statisticalList) {
                      if (statistical.keys.first == attendance.nameStudent) {
                        isStatisticalExist = true;
                        break;
                      }
                    }
                    if (isStatisticalExist) {
                      for (var statistical in statisticalList) {
                        if (statistical.keys.first == attendance.nameStudent) {
                          statistical[attendance.nameStudent] =
                              statistical[attendance.nameStudent]! + 1;
                          break;
                        }
                      }
                    } else {
                      statisticalList.add(presentCountMap);
                    }
                  }
                }

                List<Map<String, int>> presentList = statisticalList.toList();

                var excel = Excel.createExcel();
                var sheet = excel['Sheet1'];

                sheet
                  ..cell(CellIndex.indexByString('A1')).value = 'Tên'
                  ..cell(CellIndex.indexByString('B1')).value = 'Có mặt'
                  ..cell(CellIndex.indexByString('C1')).value = 'Vắng';

                var rowIndex = 2;
                for (var statistical in presentList) {
                  sheet
                    ..cell(CellIndex.indexByString('A$rowIndex')).value =
                        statistical.keys.first
                    ..cell(CellIndex.indexByString('B$rowIndex')).value =
                        statistical.values.first
                    ..cell(CellIndex.indexByString('C$rowIndex')).value =
                        data.lessons.length - statistical.values.first;

                  rowIndex++;
                }
                final excelData = excel.encode();
                final checkPermission = await getPublicDirectoryPath(ref);

                if (checkPermission) {
                  final pathDownload = ref.read(pathDownloadProvider);
                  final pathDcim = ref.read(pathDcimProvider);
                  final pathDocument = ref.read(pathDocumentProvider);
                  String now =
                      DateFormat('dd-MM-yyyy-HH-mm-ss').format(DateTime.now());
                  if (pathDownload.isNotEmpty) {
                    final filePath =
                        '$pathDownload/ThongKe-${widget.nameSubject}-$now.xlsx';
                    final file = File(filePath);
                    if (presentList.isEmpty) {
                      if (context.mounted) {
                        showSnackBarCustom(
                            context,
                            snack.ContentType.warning,
                            'Có một vấn đề nhỏ!',
                            'Danh sách điểm danh của bạn đang trống, vui lòng kiểm tra lại!');
                      }
                    } else {
                      await file.writeAsBytes(excelData!).then((value) =>
                          showSnackBarCustom(
                              context,
                              snack.ContentType.success,
                              'Thành công!',
                              'Xuất Excel thành công  $filePath'));
                      developer.log('Excel file created at: $filePath');
                    }
                  } else if (pathDownload.isEmpty && pathDocument.isNotEmpty) {
                    final filePath =
                        '$pathDocument/ThongKe-${widget.nameSubject}-$now.xlsx';
                    final file = File(filePath);
                    if (studentData.isEmpty) {
                      if (context.mounted) {
                        showSnackBarCustom(
                            context,
                            snack.ContentType.warning,
                            'Có một vấn đề nhỏ!',
                            'Danh sách điểm danh của bạn đang trống, vui lòng kiểm tra lại!');
                      }
                    } else {
                      await file.writeAsBytes(excelData!).then((value) =>
                          showSnackBarCustom(
                              context,
                              snack.ContentType.success,
                              'Thành công!',
                              'Xuất Excel thành công  $filePath'));
                      developer.log('Excel file created at: $filePath');
                    }
                  } else if (pathDownload.isEmpty ||
                      pathDocument.isEmpty && pathDcim.isNotEmpty) {
                    final filePath =
                        '$pathDcim/ThongKe-${widget.nameSubject}-$now.xlsx';
                    final file = File(filePath);
                    if (studentData.isEmpty) {
                      if (context.mounted) {
                        showSnackBarCustom(
                            context,
                            snack.ContentType.warning,
                            'Có một vấn đề nhỏ!',
                            'Danh sách điểm danh của bạn đang trống, vui lòng kiểm tra lại!');
                      }
                    } else {
                      await file.writeAsBytes(excelData!).then((value) =>
                          showSnackBarCustom(
                              context,
                              snack.ContentType.success,
                              'Thành công!',
                              'Xuất Excel thành công $filePath'));
                      developer.log('Excel file created at: $filePath');
                    }
                  }
                } else {
                  getPublicDirectoryPath(ref);
                }

                return const SizedBox();
              },
              error: (error, stackTrace) => ErrorText(text: error.toString()),
              loading: () => const Loader2(),
            );
      },
    );
  }

  Widget _tabBar() {
    return Container(
      height: 60.h,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: AnimationLimiter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 375),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              TabBar(
                overlayColor: const MaterialStatePropertyAll<Color>(
                  Colors.transparent,
                ),
                physics: const BouncingScrollPhysics(),
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: AppTheme.nearlyDarkBlue,
                    width: 4.0,
                    strokeAlign: 8,
                  ),
                  insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                ),
                onTap: (index) => _handleTabSelection(),
                labelColor: AppTheme.nearlyDarkBlue,
                unselectedLabelColor: const Color(0xffA8A8A8),
                controller: _tabController,
                labelStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 17.h,
                ),
                tabs: myTabs.map((e) => e).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _lessonsWidget(WidgetRef ref, UserModel user) {
    return Padding(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.nameSubject.isNotEmpty)
            ref.watch(countLessonsProvider(widget.idSubject)).when(
                  data: (data) => TextWidget(
                    text: 'Hôm nay có $data buổi học',
                    color: AppTheme.darkerText,
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                  ),
                  error: (error, stackTrace) =>
                      ErrorText(text: error.toString()),
                  loading: () => const Loader(),
                ),
          const Divider(thickness: 2, color: AppTheme.darkerText),
          Gap(10.h),
          Expanded(
            child: (widget.nameSubject.isNotEmpty)
                ? ref.watch(getLessonProvider(widget.idSubject)).when(
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
                                        'Không có buổi nào, thử tạo 1 buổi nào!',
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
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index) {
                              final lesson = data[index];
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
                                            curve: Curves.linear,
                                            type:
                                                PageTransitionType.bottomToTop,
                                            child: AttendanceScreen(
                                              idClass: '',
                                              nameClass: '',
                                              secondsAttendance: '',
                                              idLesson: lesson.id,
                                              lessonName: lesson.lessonName,
                                            ),
                                          ),
                                        );
                                      },
                                      child: CardLesson(
                                        nameLesson: lesson.lessonName,
                                        idLesson: lesson.id,
                                        endAttendance: lesson.endAttendance,
                                        present: lesson.present,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Gap(3.w),
                          ),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader(),
                    )
                : ref.watch(getClassProvider(user.uid)).when(
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
                                      child: Image.asset(
                                          'assets/no-results.png',
                                          fit: BoxFit.cover,
                                          color: AppTheme.darkText),
                                    )),
                                SizedBox(
                                  width: context.screenSize.width,
                                  height: 40.h,
                                  child: FittedBox(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      'Bạn đang không có nhóm nào cả, thử tạo 1 nhóm trải nghiệm ngay nào!',
                                      style: AppTheme.body2.copyWith(
                                          color: AppTheme.darkText,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                        return AnimationLimiter(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: data.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final classIndex = data[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                      child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          onPressed: (context) {
                                            ref
                                                .read(classControllerProvider
                                                    .notifier)
                                                .deleteClassIdById(
                                                    classIndex.id);
                                          },
                                          backgroundColor:
                                              const Color(0xFFFE95B6),
                                          foregroundColor: AppTheme.nearlyWhite,
                                          icon: Icons.delete,
                                          label: 'Xóa',
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.heavyImpact();
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            type: PageTransitionType.scale,
                                            alignment: Alignment.topCenter,
                                            duration: const Duration(
                                                milliseconds: 400),
                                            isIos: true,
                                            child: AttendanceScreen(
                                              idClass: classIndex.id,
                                              nameClass: classIndex.nameClass,
                                              secondsAttendance:
                                                  classIndex.endAttendance,
                                              idLesson: '',
                                              lessonName: '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: CardClassCustom(
                                        className: classIndex.nameClass,
                                        present: classIndex.present,
                                        sumStudent:
                                            classIndex.listUserPhone.length,
                                        absent: classIndex.absent,
                                      ),
                                    ),
                                  )),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Gap(8.w),
                          ),
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(text: error.toString()),
                      loading: () => const Loader(),
                    ),
          )
        ],
      ),
    );
  }
}
