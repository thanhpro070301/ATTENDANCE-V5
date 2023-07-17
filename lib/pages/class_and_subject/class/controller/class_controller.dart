// ignore_for_file: use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:attendance_/common/enum/status_attendance_enum.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/models/attendance_for_class/attendance_for_class_model.dart';
import 'package:attendance_/models/class_model/class_model.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/attendance/attendance.dart';
import 'package:attendance_/pages/attendance/controller/attendance_controller.dart';
import 'package:attendance_/pages/attendance/repository/attendance_repository.dart';
import 'dart:developer' as developer;
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/class_and_subject/class/repository/class_repository.dart';
import 'package:quickalert/quickalert.dart';
import 'package:uuid/uuid.dart';

final classControllerProvider =
    StateNotifierProvider.autoDispose<ClassController, bool>(
  (ref) {
    final classRepository = ref.watch(classRepositoryProvider);
    final attendanceRepository = ref.watch(attendanceRepositoryProvider);

    return ClassController(
        classRepository: classRepository,
        ref: ref,
        attendanceRepository: attendanceRepository);
  },
);

final getClassProvider = StreamProvider.autoDispose.family(
  (ref, String uid) {
    final classController = ref.watch(classControllerProvider.notifier);
    return classController.getClasses(uid);
  },
);

final getClassByIdProvider = StreamProvider.autoDispose.family(
  (ref, String idClass) {
    final classController = ref.watch(classControllerProvider.notifier);
    return classController.getClassesById(idClass);
  },
);

final getClassByIdFutureProvider = FutureProvider.autoDispose.family(
  (ref, String idClass) {
    final classController = ref.watch(classControllerProvider.notifier);
    return classController.getClassByIdFuture(idClass);
  },
);

final getUserPhoneOfClassProvider = StreamProvider.autoDispose.family(
  (ref, String idClass) {
    final classController = ref.watch(classControllerProvider.notifier);
    return classController.getUserPhonesOfClass(idClass);
  },
);

final getUserPhoneOfClassFutureProvider = FutureProvider.autoDispose.family(
  (ref, String idClass) {
    final classController = ref.watch(classControllerProvider.notifier);
    return classController.getUserPhonesOfClassFuture(idClass);
  },
);

final checkUserExistInClassProvider = FutureProvider.autoDispose.family(
  (ref, String phoneNumber) {
    final classController = ref.watch(classControllerProvider.notifier);
    return classController.checkUserExistInClass(phoneNumber);
  },
);

final getUserIsNotHaveAttendanceProvider = StreamProvider.autoDispose.family(
  (ref, String idClass) {
    final classController = ref.watch(classControllerProvider.notifier);
    return classController.getUserIsNotHaveAttendance(idClass);
  },
);

class ClassController extends StateNotifier<bool> {
  final ClassRepository _classRepository;
  final Ref _ref;
  final AttendanceRepository _attendanceRepository;

  ClassController(
      {required ClassRepository classRepository,
      required Ref ref,
      required AttendanceRepository attendanceRepository})
      : _classRepository = classRepository,
        _ref = ref,
        _attendanceRepository = attendanceRepository,
        super(false);

  void createClass(BuildContext context, String className,
      List<String> userPhones, String idClass) async {
    final user = _ref.read(userProvider)!;
    String dateNow = formatDate(DateTime.now());
    _ref.read(remainingTimeForClassProvider.notifier).state = 0;
    state = true;
    ClassModel classModel = ClassModel(
      id: idClass,
      createdAt: dateNow,
      listUserPhone: userPhones,
      nameClass: className,
      endAttendance: '',
      uidCreator: user.uid,
      updatedAt: dateNow,
      absent: 0,
      present: 0,
    );
    final res = await _classRepository.createClass(classModel);

    res.fold(
        (l) => showSnackBarCustom(
            context, ContentType.failure, 'Oh Snap!', l.message), (r) async {
      await createAttendance(context, idClass);
      state = false;
      if (context.mounted) {
        _ref.read(remainingTimeForClassProvider.notifier).state = 0;
        Navigator.of(context).pop();
        showSnackBarCustom(context, ContentType.success, 'Thành công',
            'Chúc mừng bạn đã tạo nhóm thành công!');
      }
    });
  }

  Future<void> createAttendance(BuildContext context, String idClass) async {
    final getClass = await getClassByIdFuture(idClass);
    final List<String> userPhones =
        await getUserPhonesOfClassFuture(getClass!.id);
    String createdAt = DateFormat('dd-MM-yyyy').format(DateTime.now());

    for (int i = 0; i < userPhones.length; i++) {
      final user = await getUserDataByPhoneFuture(userPhones[i]);

      final isHaveAttendance = await _attendanceRepository
          .checkAttendanceStatusInClassOfUser(user.uid, idClass);
      debugPrint('${user.phoneNumber}${isHaveAttendance.toString()}');

      if (!isHaveAttendance) {
        _ref
            .read(attendanceControllerProvider.notifier)
            .createAttendanceForClass(
              AttendanceForClassModel(
                id: const Uuid().v4(),
                idClass: idClass,
                nameStudent: user.name,
                idStudent: user.uid,
                phoneStudent: user.phoneNumber,
                code: '',
                uidCreatorClass: getClass.uidCreator,
                statusAttendance: StatusAttendance.noAttendance.name,
                timeAttendance: '',
                createdAt: createdAt,
                deviceName: '',
                location: '',
              ),
            );
      }
    }

    return;
  }

  Stream<List<String>> getUserIsNotHaveAttendance(String idClass) {
    return _classRepository.getNonExistingUserPhonesStream(idClass);
  }

  void checkAttendanceOfUser(
    BuildContext context,
    UserModel user,
  ) async {
    final listClassExitsUser = await checkUserExistInClass(user.phoneNumber);
    String createdAt = DateFormat('dd-MM-yyyy').format(DateTime.now());
    for (int i = 0; i < listClassExitsUser.length; i++) {
      final isHaveAttendance =
          await _attendanceRepository.checkAttendanceStatusInClassOfUser(
              user.uid, listClassExitsUser[i].id);

      if (isHaveAttendance == false) {
        _ref
            .read(attendanceControllerProvider.notifier)
            .createAttendanceForClass(
              AttendanceForClassModel(
                id: const Uuid().v4(),
                idClass: listClassExitsUser[i].id,
                phoneStudent: user.phoneNumber,
                nameStudent: user.name,
                idStudent: user.uid,
                code: '',
                uidCreatorClass: listClassExitsUser[i].uidCreator,
                statusAttendance: StatusAttendance.noAttendance.name,
                timeAttendance: '',
                createdAt: createdAt,
                deviceName: '',
                location: '',
              ),
            );
      }
    }
  }

  Stream<List<ClassModel>> getClasses(String uid) {
    return _classRepository.getClasses(uid);
  }

  Stream<List<String>> getUserPhonesOfClass(String idClass) {
    return _classRepository.getUserPhonesOfClass(idClass);
  }

  Future<List<String>> getUserPhonesOfClassFuture(String idClass) async {
    return await _classRepository.getUserPhonesOfClassCheckExitsFuture(idClass);
  }

  Stream<ClassModel?> getClassesById(String idClass) {
    return _classRepository.getClassById(idClass);
  }

  Future<ClassModel?> getClassByIdFuture(String idClass) async {
    return await _classRepository.getClassByIdFuture(idClass);
  }

  Future<UserModel> getUserDataByPhoneFuture(String phoneNumber) async {
    return await _classRepository.getUserDataByPhoneFuture(phoneNumber);
  }

  Future<List<ClassModel>> checkUserExistInClass(String userPhone) async {
    return await _classRepository.checkUserExistInClass(userPhone);
  }

  void updateEndAttendanceForClass(String idClass) async {
    await _classRepository.updateEndAttendanceForClass(idClass: idClass);
  }

  Future<int> getEndTimeAttendanceOfClass(String idClass) async {
    final res = await _classRepository.getEndTimeAttendanceOfClass(idClass);
    late int seconds;
    res.fold(
      (l) {},
      (r) {
        seconds = r;
      },
    );
    return seconds;
  }

  void addStudentForClass(
      BuildContext context, String idClass, List<String> listUserPhone) async {
    state = true;

    final res = await _classRepository.addStudentForClass(
        idClass: idClass, listUserPhone: listUserPhone);
    state = false;
    res.fold((l) => developer.log(l.message), (r) async {
      Navigator.pop(context);
      await createAttendance(context, idClass).then(
        (value) => QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Thêm học sinh vào nhóm thành công.",
        ),
      );
    });
  }

  void deleteClassIdById(String idClass) async {
    await _classRepository.deleteAttendanceByClassId(idClass);
  }
}
