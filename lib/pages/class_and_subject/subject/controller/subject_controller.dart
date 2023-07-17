import 'package:attendance_/models/attendance_for_lesson_model/attendance_model.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/models/subjects_model/subject_model.dart';

import 'package:attendance_/pages/auth/provider/auth_provider.dart';

import 'package:attendance_/pages/class_and_subject/subject/repository/subject_repository.dart';
import 'package:uuid/uuid.dart';

final subjectControllerProvider =
    StateNotifierProvider.autoDispose<SubjectController, bool>(
  (ref) {
    final subjectRepository = ref.watch(subjectRepositoryProvider);

    return SubjectController(
      subjectRepository: subjectRepository,
      ref: ref,
    );
  },
);

final getSubjectProvider = StreamProvider.autoDispose.family(
  (ref, String uid) {
    final homeV2Controller = ref.watch(subjectControllerProvider.notifier);
    return homeV2Controller.getSubjects(uid);
  },
);

final getSubjectByIdProvider = StreamProvider.autoDispose.family(
  (ref, String idSubject) {
    final lessonController = ref.watch((subjectControllerProvider.notifier));
    return lessonController.getSubjectById(idSubject);
  },
);

final countLessonsProvider =
    StreamProvider.autoDispose.family((ref, String idSubject) {
  final lessonController = ref.watch((subjectControllerProvider.notifier));
  return lessonController.countLessons(idSubject);
});

final getAttendanceByLessonUseIdSubjectProvider =
    StreamProvider.autoDispose.family((ref, String idSubject) {
  final lessonController = ref.watch((subjectControllerProvider.notifier));
  return lessonController.getAttendanceByLessonUseIdSubject(idSubject);
});

class SubjectController extends StateNotifier<bool> {
  final SubjectRepository _subjectRepository;
  final Ref _ref;

  SubjectController({
    required SubjectRepository subjectRepository,
    required Ref ref,
  })  : _subjectRepository = subjectRepository,
        _ref = ref,
        super(false);

  void createSubject(BuildContext context, String subjectName) async {
    final user = _ref.read(userProvider)!;
    String dateNow = formatDate(DateTime.now());
    state = true;
    SubjectModel subjectModel = SubjectModel(
      id: const Uuid().v4(),
      uid: user.uid,
      lessons: [],
      listUserPhone: [],
      createdAt: dateNow,
      updatedAt: dateNow,
      nameSubject: subjectName,
      nameTeacher: user.name,
    );
    final res = await _subjectRepository.createSubject(subjectModel);
    state = false;
    res.fold(
        (l) => showSnackBarCustom(
            context, ContentType.failure, 'Oh Snap!', l.message), (r) {
      showSnackBarCustom(context, ContentType.success, 'Thành công',
          'Chúc mừng bạn đã tạo chủ đề thành công!');
    });
  }

  Stream<List<SubjectModel>> getSubjects(String uid) {
    return _subjectRepository.getSubjects(uid);
  }

  void updateSubject({
    required BuildContext context,
    required String id,
    required SubjectModel subjectModel,
  }) async {
    state = true;
    final res = await _subjectRepository.updateSubject(
        subjectModel: subjectModel, id: id);
    state = false;
    res.fold(
      (l) => showSnackBarCustom(
          context, ContentType.failure, 'Oh Snap!', l.message),
      (r) => Navigator.of(context).pop(),
    );
  }

  void updateLessonForSubject(
      {required String idSubject, required String lessonId}) async {
    state = true;

    final res = await _subjectRepository.updateLessonForSubject(
        idSubject: idSubject, idLesson: lessonId);
    state = false;
    res.fold((l) => debugPrint(l.message), (r) {});
  }

  Stream<SubjectModel?> getSubjectById(String idSubject) {
    return _subjectRepository.getSubjectById(idSubject);
  }

  Stream<int> countLessons(String idSubject) {
    return _subjectRepository.countLessons(idSubject);
  }

  Future<SubjectModel?> getSubjectByIdLesson(String idLesson) async {
    return await _subjectRepository.getSubjectByIdLesson(idLesson);
  }

  Stream<List<AttendanceModel>> getAttendanceByLessonUseIdSubject(
      String idStudent) {
    return _subjectRepository.getAttendanceByLessonUseIdSubject(idStudent);
  }
}
