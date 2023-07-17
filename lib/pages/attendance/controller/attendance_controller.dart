import 'dart:developer' as developer;

import 'package:attendance_/common/enum/status_attendance_enum.dart';
import 'package:attendance_/models/subjects_model/subject_model.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/class_and_subject/subject/controller/subject_controller.dart';
import 'package:attendance_/pages/user_profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/quickalert.dart';

import 'package:attendance_/common/utils.dart';
import 'package:attendance_/models/attendance_for_class/attendance_for_class_model.dart';
import 'package:attendance_/models/attendance_for_lesson_model/attendance_model.dart';
import 'package:attendance_/pages/attendance/repository/attendance_repository.dart';
import 'package:attendance_/provider/storage_repository.dart';
import 'package:uuid/uuid.dart';

class AttendanceQuery {
  final String uid;
  final String date;

  AttendanceQuery(this.uid, this.date);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceQuery &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          date == other.date;

  @override
  int get hashCode => uid.hashCode ^ date.hashCode;
}

class AttendanceClassQuery {
  final String idUser;
  final String idClass;
  AttendanceClassQuery(this.idUser, this.idClass);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceClassQuery &&
        other.idUser == idUser &&
        other.idClass == idClass;
  }

  @override
  int get hashCode => idUser.hashCode ^ idClass.hashCode;
}

class AttendanceByDateAndObjectIdQuery {
  final String idUser;
  final String objectId;
  final String date;
  AttendanceByDateAndObjectIdQuery(this.idUser, this.objectId, this.date);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceByDateAndObjectIdQuery &&
        other.idUser == idUser &&
        other.date == date &&
        other.objectId == objectId;
  }

  @override
  int get hashCode => idUser.hashCode ^ objectId.hashCode ^ date.hashCode;
}

final attendanceControllerProvider =
    StateNotifierProvider.autoDispose<AttendanceController, bool>(
  (ref) {
    final attendanceRepository = ref.watch(attendanceRepositoryProvider);
    final storageRepository = ref.watch(storageRepositoryProvider);

    return AttendanceController(
      attendanceRepository: attendanceRepository,
      ref: ref,
      storageRepository: storageRepository,
    );
  },
);
final getAttendanceByLessonProvider = StreamProvider.autoDispose.family(
  (ref, String lessonId) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);
    return attendanceController.getAttendanceByIdLesson(
      lessonId: lessonId,
    );
  },
);

final getAttendanceByDateProvider = StreamProvider.autoDispose.family(
  (ref, AttendanceQuery attendanceQuery) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);

    return attendanceController.getAttendanceByDate(
        attendanceQuery:
            AttendanceQuery(attendanceQuery.uid, attendanceQuery.date));
  },
);

final findAllAttendanceBySubjectIdAndStudentIdProvider =
    StreamProvider.autoDispose.family(
  (ref, AttendanceClassQuery request) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);

    return attendanceController.findAllAttendanceBySubjectIdAndStudentId(
        request: request);
  },
);
final findAllAttendanceBySubjectIdAndStudentIdAndDate =
    StreamProvider.autoDispose.family(
  (ref, AttendanceByDateAndObjectIdQuery request) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);

    return attendanceController.findAllAttendanceBySubjectIdAndStudentIdAndDate(
        request: request);
  },
);

final getAllAttendanceByStudentId = StreamProvider.autoDispose.family(
  (
    ref,
    String uid,
  ) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);
    return attendanceController.getAllAttendanceByStudentId(uid);
  },
);
final getAllAttendanceBySubjectId = StreamProvider.autoDispose.family(
  (
    ref,
    String subjectId,
  ) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);
    return attendanceController.getAllAttendanceBySubjectId(subjectId);
  },
);

final countAttendanceOfLessonProvider = StreamProvider.autoDispose.family(
  (ref, String idLesson) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);
    return attendanceController.countAttendanceOfLesson(idLesson);
  },
);

final checkAttendanceStatusInClassOfUserProvider =
    FutureProvider.autoDispose.family(
  (ref, AttendanceClassQuery attendanceClassQuery) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);
    return attendanceController.checkAttendanceStatusInClassOfUser(
        attendanceClassQuery.idUser, attendanceClassQuery.idClass);
  },
);

//*CLASS=============================================

final getAttendanceClassByDateProvider = StreamProvider.autoDispose.family(
  (ref, AttendanceQuery attendanceQuery) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);

    return attendanceController.getAttendanceClassByDate(
        attendanceQuery:
            AttendanceQuery(attendanceQuery.uid, attendanceQuery.date));
  },
);

final getAttendanceClassByStudentIdProvider = StreamProvider.autoDispose.family(
  (ref, String studentId) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);

    return attendanceController.getAttendanceClassByStudentId(
        studentId: studentId);
  },
);

final getAttendanceClassByStudentIdAndClassId =
    StreamProvider.autoDispose.family(
  (ref, AttendanceClassQuery request) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);

    return attendanceController.getAttendanceClassByStudentIdAndClassId(
        request: request);
  },
);

final getAttendanceByDateAndClassIdAndStudentId =
    StreamProvider.autoDispose.family(
  (ref, AttendanceByDateAndObjectIdQuery request) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);

    return attendanceController.getAttendanceByDateAndClassIdAndStudentId(
        request: request);
  },
);

final getAttendanceByClassProvider = StreamProvider.autoDispose.family(
  (ref, String classId) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);
    return attendanceController.getAttendanceByClass(
      classId: classId,
    );
  },
);

final getAttendanceByNameCreatorClass = StreamProvider.autoDispose.family(
  (ref, String username) {
    final attendanceController =
        ref.watch(attendanceControllerProvider.notifier);
    return attendanceController.getAttendanceByNameCreatorClass(
      username: username,
    );
  },
);

class AttendanceController extends StateNotifier<bool> {
  final AttendanceRepository _attendanceRepository;
  final Ref _ref;

  AttendanceController(
      {required AttendanceRepository attendanceRepository,
      required Ref ref,
      required StorageRepository storageRepository})
      : _attendanceRepository = attendanceRepository,
        _ref = ref,
        super(false);

  void createAttendanceForLesson({
    required BuildContext context,
    required String idLesson,
  }) async {
    state = true;
    await getCurrentPosition(_ref);
    final user = _ref.read(userProvider)!;
    final deviceId = await getDeviceId();

    final userAddress = _ref.read(userAddressProvider);
    SubjectModel? subject = await _ref
        .read(subjectControllerProvider.notifier)
        .getSubjectByIdLesson(idLesson);

    String dateNow = formatDate(DateTime.now());
    final attendanceModel = AttendanceModel(
      id: const Uuid().v4(),
      statusAttendance: StatusAttendance.present.name,
      createdAt: dateNow,
      nameStudent: user.name,
      uidCreatorLesson: subject?.uid ?? '',
      idStudent: user.uid,
      idLesson: idLesson,
      idSubject: subject?.id ?? '',
      timeAttendance: dateNow,
      deviceName: deviceId,
      location: userAddress,
    );
    final res = await _attendanceRepository.createAttendanceForLesson(
        attendanceModel: attendanceModel);
    state = false;

    res.fold(
        (l) => QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              text: 'Chưa tới giờ điểm danh.',
            ).then((value) => Navigator.pop(context)), (r) {
      if (r == 'HaveAttendance') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          text: 'Bạn đã điểm danh rồi!!!.',
        ).then((value) => Navigator.pop(context));
      } else if (r == 'NotTimeYetAttendance') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Chưa tới giờ điểm danh.',
        ).then((value) => Navigator.pop(context));
      } else if (r == 'CloseAttendance') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Đã hết giờ điểm danh.',
        ).then((value) => Navigator.pop(context));
      } else if (r == 'AttendanceSuccess') {
        if (context.mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Xin chúc mừng! Bạn đã điểm danh thành công.',
          ).then((value) => Navigator.pop(context));

          _ref
              .read(attendanceControllerProvider.notifier)
              .countAttendanceStatus(attendanceModel.idLesson);
        }
      }
    });
  }

  Stream<List<AttendanceModel>> getAttendanceByIdLesson({
    required String lessonId,
  }) async* {
    yield* _attendanceRepository.getAttendanceByIdLesson(
      lessonId,
    );
  }

  Stream<List<AttendanceModel>> getAllAttendanceByStudentId(String uid) async* {
    yield* _attendanceRepository.getAllAttendanceByStudentId(
      uid,
    );
  }

  Stream<List<AttendanceModel>> getAllAttendanceBySubjectId(
      String subjectId) async* {
    yield* _attendanceRepository.getAllAttendanceBySubjectId(
      subjectId,
    );
  }

  void updateStatusForLesson({
    required BuildContext context,
    required String id,
    required String statusAttendance,
    required String idLesson,
  }) async {
    state = true;
    final res = await _attendanceRepository.updateStatusForLesson(
        timeAttendance: DateTime.now(),
        statusAttendance: statusAttendance,
        id: id);
    state = false;
    res.fold((l) => developer.log(l.message), (r) {
      _ref
          .read(attendanceControllerProvider.notifier)
          .countAttendanceStatus(idLesson);
    });
  }

  void countAttendanceStatus(String idLesson) async {
    return _attendanceRepository.countAttendanceStatus(idLesson);
  }

  Stream<List<AttendanceModel>> getAttendanceByDate(
      {required AttendanceQuery attendanceQuery}) {
    return _attendanceRepository.getAttendanceByDate(
        attendanceQuery.uid, attendanceQuery.date);
  }

  Stream<List<AttendanceModel>> findAllAttendanceBySubjectIdAndStudentId(
      {required AttendanceClassQuery request}) {
    return _attendanceRepository
        .findAllAttendanceBySubjectIdAndStudentId(request);
  }

  Stream<List<AttendanceModel>> findAllAttendanceBySubjectIdAndStudentIdAndDate(
      {required AttendanceByDateAndObjectIdQuery request}) {
    return _attendanceRepository
        .findAllAttendanceBySubjectIdAndStudentIdAndDate(request);
  }

  Stream<int> countAttendanceOfLesson(String idLesson) {
    return _attendanceRepository.countAttendanceOfLesson(idLesson);
  }

  void attendanceSubjectStatisticsByWeek(
      String idSubject, DateTime dateTime) async {
    return _attendanceRepository.attendanceSubjectStatisticsByWeek(
        idSubject, dateTime);
  }

  //*CLASS======================================================================
  //*CLASS======================================================================
  //*CLASS======================================================================
  //*CLASS======================================================================
  //*CLASS======================================================================
  //*CLASS======================================================================

  void createAttendanceForClass(AttendanceForClassModel attendanceModel) async {
    await _attendanceRepository.createAttendanceForClass(
        attendanceModel: attendanceModel);
  }

  Future<bool> checkAttendanceStatusInClassOfUser(
      String idUser, String idClass) async {
    return await _attendanceRepository.checkAttendanceStatusInClassOfUser(
      idUser,
      idClass,
    );
  }

  Stream<List<AttendanceForClassModel>> getAttendanceClassByDate(
      {required AttendanceQuery attendanceQuery}) {
    return _attendanceRepository.getAttendanceClassByDate(
        attendanceQuery.uid, attendanceQuery.date);
  }

  Stream<List<AttendanceForClassModel>> getAttendanceClassByStudentId(
      {required String studentId}) {
    return _attendanceRepository.getAttendanceClassByStudentId(studentId);
  }

  Stream<List<AttendanceForClassModel>> getAttendanceClassByStudentIdAndClassId(
      {required AttendanceClassQuery request}) {
    return _attendanceRepository
        .getAttendanceClassByStudentIdAndClassId(request);
  }

  Stream<List<AttendanceForClassModel>>
      getAttendanceByDateAndClassIdAndStudentId(
          {required AttendanceByDateAndObjectIdQuery request}) {
    return _attendanceRepository
        .getAttendanceByDateAndClassIdAndStudentId(request);
  }

  void countAttendanceStatusByClass(String idClass) async {
    return _attendanceRepository.countAttendanceStatusByClass(idClass);
  }

  void updateAttendanceClassByStudentId({
    required BuildContext context,
    required String idStudent,
    required String classId,
  }) async {
    state = true;
    final user = _ref.read(userProvider)!;
    final deviceId = await getDeviceId();
    await getCurrentPosition(_ref);
    final userAddress = _ref.read(userAddressProvider);

    final res = await _attendanceRepository.updateAttendanceClassByStudentId(
        idStudent, classId, userAddress, deviceId, user.code);

    state = false;
    res.fold(
        (l) => QuickAlert.show(
              context: context,
              type: QuickAlertType.info,
              text: 'Chưa tới giờ điểm danh!',
            ), (r) {
      if (r == 'SuccessAttendance') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Xin chúc mừng bạn đã điểm danh thành công.',
        );
      } else if (r == 'CloseAttendance') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'Đã hết giờ điểm danh!!',
        );
      } else if (r == 'isNotHaveCode') {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.confirm,
            title: 'Có 1 vấn đề nhỏ',
            confirmBtnText: 'Có',
            cancelBtnText: 'Không',
            text:
                'Bạn chưa cập nhật mã code, bạn có muốn cập nhật ngay không?!',
            onCancelBtnTap: () => Navigator.pop(context),
            onConfirmBtnTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  alignment: Alignment.topCenter,
                  child: EditProfile(uid: user.uid),
                ),
              );
            });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          text: 'Bạn đã điểm danh vào lúc $r!',
        );
      }
    });
  }

  Stream<List<AttendanceForClassModel>> getAttendanceByClass({
    required String classId,
  }) async* {
    yield* _attendanceRepository.getAttendanceByClass(
      classId,
    );
  }

  Stream<List<AttendanceForClassModel>> getAttendanceByNameCreatorClass({
    required String username,
  }) async* {
    yield* _attendanceRepository.getAttendanceByNameCreatorClass(
      username,
    );
  }

  void updateStatusForClass({
    required BuildContext context,
    required String id,
    required String statusAttendance,
    required String idClass,
  }) async {
    state = true;
    final res = await _attendanceRepository.updateStatusForClass(
      timeAttendance: DateTime.now(),
      statusAttendance: statusAttendance,
      id: id,
    );
    state = false;
    res.fold((l) => developer.log(l.message), (r) {
      _ref
          .read(attendanceControllerProvider.notifier)
          .countAttendanceStatusByClass(idClass);
    });
  }

  void updateAbsentAttendanceByClass(String idClass) async {
    final res =
        await _attendanceRepository.updateAbsentAttendanceByClass(idClass);
    res.fold((l) => developer.log(l.message), (r) {
      _ref
          .read(attendanceControllerProvider.notifier)
          .countAttendanceStatusByClass(idClass);
    });
  }

  void resetAttendanceByClass(String idClass) async {
    final res = await _attendanceRepository.resetAttendanceByClass(idClass);
    res.fold((l) => developer.log(l.message), (r) {
      developer.log('Reset thành công');
      _ref
          .read(attendanceControllerProvider.notifier)
          .countAttendanceStatusByClass(idClass);
    });
  }

  Future<List<AttendanceForClassModel>> getAttendanceByClassFuture(
      String idClass) async {
    return await _attendanceRepository.getAttendanceByClassFuture(idClass);
  }
}
