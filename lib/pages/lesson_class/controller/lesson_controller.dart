import 'package:attendance_/pages/attendance/attendance.dart';
import 'package:attendance_/pages/class_and_subject/subject/repository/subject_repository.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/models/lessons_model/lessons_model.dart';
import 'package:attendance_/pages/lesson_class/repository/lesson_repository.dart';
import 'package:uuid/uuid.dart';

final listStudentByClass =
    StateProvider.autoDispose<List<String>?>((ref) => null);

final lessonControllerProvider =
    StateNotifierProvider.autoDispose<LessonController, bool>(
  (ref) {
    final lessonRepository = ref.watch(lessonRepositoryProvider);
    final subjectRepository = ref.watch(subjectRepositoryProvider);
    return LessonController(
      lessonRepository: lessonRepository,
      subjectRepository: subjectRepository,
      ref: ref,
    );
  },
);

final getLessonByIdProvider = StreamProvider.autoDispose.family(
  (ref, String idLesson) {
    final lessonController = ref.watch(lessonControllerProvider.notifier);
    return lessonController.getIdLesson(idLesson);
  },
);

final getLessonByIdFutureProvider = FutureProvider.autoDispose.family(
  (ref, String idLesson) {
    final lessonController = ref.watch(lessonControllerProvider.notifier);
    return lessonController.getIdLessonFuture(idLesson);
  },
);
final getLessonProvider = StreamProvider.autoDispose.family(
  (ref, String idSubject) {
    final lessonController = ref.watch(lessonControllerProvider.notifier);
    return lessonController.getLessons(idSubject);
  },
);

final countStudentOfLessonProvider = StreamProvider.autoDispose.family(
  (ref, String idLesson) {
    final lessonController = ref.watch(lessonControllerProvider.notifier);
    return lessonController.countStudentOfLesson(idLesson);
  },
);

class LessonController extends StateNotifier<bool> {
  final LessonRepository _lessonRepository;
  final SubjectRepository _subjectRepository;
  final Ref _ref;

  LessonController({
    required LessonRepository lessonRepository,
    required Ref ref,
    required SubjectRepository subjectRepository,
  })  : _lessonRepository = lessonRepository,
        _ref = ref,
        _subjectRepository = subjectRepository,
        super(false);

  void createLesson({
    required BuildContext context,
    required String nameSubject,
    required String idSubject,
    required String location,
    required String roomName,
  }) async {
    String dateNow = formatDate(DateTime.now());
    final id = const Uuid().v4();
    state = true;
    final lessonIndex = await _subjectRepository.countLessonsFuture(idSubject);
    LessonsModel lessonModel = LessonsModel(
      id: id,
      idSubject: idSubject,
      lessonName: "Buổi ${lessonIndex + 1}",
      location: location,
      roomName: roomName,
      endAttendance: '',
      subjectName: nameSubject,
      absent: 0,
      present: 0,
      createdAt: dateNow,
    );

    final res = await _lessonRepository.createLesson(lessonModel);

    state = false;
    res.fold(
        (l) => showSnackBarCustom(
            context, ContentType.failure, 'Oh Snap!', l.message), (r) {
      showSnackBarCustom(context, ContentType.success, 'Thành công!',
          'Chúc mừng bạn đã tạo buổi học thành công');
      _ref.read(remainingTimeForLessonProvider.notifier).state = 0;

      Navigator.of(context).pop();
    });
  }

  Stream<List<LessonsModel>> getLessons(String idSubject) {
    return _lessonRepository.getLesson(idSubject);
  }

  Stream<LessonsModel?> getIdLesson(String idLesson) {
    return _lessonRepository.getIdLesson(idLesson);
  }

  Future<LessonsModel?> getIdLessonFuture(String idLesson) {
    return _lessonRepository.getIdLessonFuture(idLesson);
  }

  Future<String> storeFileStorage(String ref, Uint8List imageData) async {
    Reference storageRef = FirebaseStorage.instance.ref(ref);
    UploadTask uploadTask = storageRef.putData(imageData);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Stream<int> countStudentOfLesson(String idLesson) {
    return _lessonRepository.countStudentOfLesson(idLesson);
  }

  void updateEndAttendanceForLesson(String idLesson) async {
    await _lessonRepository.updateEndAttendanceForLesson(idLesson: idLesson);
  }

  Future<int> getEndTimeAttendanceOfLesson(String idLesson) async {
    return await _lessonRepository.getEndTimeAttendanceOfLesson(idLesson);
  }

  void deleteSubjectById(String idSubject) async {
    await _lessonRepository.deleteLessonsBySubjectId(idSubject);
  }
}
