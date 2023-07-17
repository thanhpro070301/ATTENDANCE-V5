import 'dart:async';
import 'dart:developer' as developer;
import 'package:attendance_/pages/class_and_subject/subject/controller/subject_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/firebase_constants.dart';
import 'package:attendance_/models/lessons_model/lessons_model.dart';

import 'package:attendance_/provider/firebase_provider.dart';
import 'package:intl/intl.dart';

final lessonRepositoryProvider = Provider.autoDispose(
  (ref) {
    final firestore = ref.watch(firebaseFirestoreProvider);
    return LessonRepository(firestore: firestore, ref: ref);
  },
);

abstract class ILessonRepository {
  CollectionReference get lessonsCollection;
  CollectionReference get user;
  FutureEitherVoid createLesson(LessonsModel lessonsModel);
  Stream<List<LessonsModel>> getLesson(String idSubject);
  Stream<LessonsModel?> getIdLesson(String idLesson);
  Stream<int> countStudentOfLesson(String idLesson);
  FutureEitherVoid updateEndAttendanceForLesson({required String idLesson});
  Future<int> getEndTimeAttendanceOfLesson(String idLesson);
  FutureEitherVoid deleteLessonsBySubjectId(String subjectId);
  FutureEitherVoid deleteAttendanceByLessonId(String lessonId);
  FutureEitherVoid deleteSubjectById(String subjectId);
  Future<LessonsModel?> getIdLessonFuture(String idLesson);
}

class LessonRepository implements ILessonRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;
  LessonRepository({required FirebaseFirestore firestore, required Ref ref})
      : _ref = ref,
        _firestore = firestore;
  @override
  CollectionReference get lessonsCollection =>
      _firestore.collection(FirebaseConstants.lessonsCollection);
  @override
  CollectionReference get user =>
      _firestore.collection(FirebaseConstants.usersCollection);

  @override
  FutureEitherVoid createLesson(LessonsModel lessonsModel) async {
    try {
      return right(await lessonsCollection
          .doc(lessonsModel.id)
          .set(lessonsModel.toJson())
          .then(
            (value) => _ref
                .read(subjectControllerProvider.notifier)
                .updateLessonForSubject(
                    idSubject: lessonsModel.idSubject,
                    lessonId: lessonsModel.id),
          ));
    } on FirebaseException catch (e) {
      return left(Failure("Error Firebase: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<LessonsModel>> getLesson(String idSubject) {
    return lessonsCollection
        .where('idSubject', isEqualTo: idSubject)
        .snapshots()
        .map((event) {
      List<LessonsModel> lessons = [];
      for (var doc in event.docs) {
        lessons.add(LessonsModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      return lessons;
    });
  }

  @override
  Stream<LessonsModel?> getIdLesson(String idLesson) {
    return lessonsCollection.doc(idLesson).snapshots().map(
        (event) => LessonsModel.fromJson(event.data() as Map<String, dynamic>));
  }

  @override
  Future<LessonsModel?> getIdLessonFuture(String idLesson) async {
    final snapshot = await lessonsCollection.doc(idLesson).get();
    if (snapshot.exists) {
      return LessonsModel.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  @override
  Stream<int> countStudentOfLesson(String idLesson) {
    final CollectionReference lessonRef = FirebaseFirestore.instance
        .collection(FirebaseConstants.lessonsCollection);

    return lessonRef.doc(idLesson).snapshots().map((lessonDoc) {
      developer.log("ID  $idLesson");

      if (lessonDoc.exists) {
        final Map<String, dynamic>? data =
            lessonDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          final List<dynamic>? students = data['student'];

          developer.log("ID lesson ${students!.length}");
          return students.length;
        }
      }

      return 0;
    });
  }

  @override
  FutureEitherVoid updateEndAttendanceForLesson(
      {required String idLesson}) async {
    final lessonDoc = lessonsCollection.doc(idLesson);

    DateTime now = DateTime.now();
    DateTime endTime = now.add(const Duration(seconds: 90));

    String endTimeStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(endTime);
    developer.log(endTimeStr);
    try {
      developer.log('Update endAtt for lesson đây..');

      return right(await lessonDoc.update({
        'endAttendance': endTimeStr,
      }));
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<int> getEndTimeAttendanceOfLesson(String idLesson) async {
    try {
      DateTime now = DateTime.now();
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.lessonsCollection)
          .doc(idLesson)
          .get();
      String endAttendanceString = snapshot['endAttendance'];
      DateTime endTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(endAttendanceString);
      Duration difference = endTime.difference(now);

      if (difference.inSeconds < 0) {
        return 0;
      }
      return difference.inSeconds;
    } catch (e) {
      rethrow;
    }
  }

  @override
  FutureEitherVoid deleteLessonsBySubjectId(String subjectId) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.lessonsCollection)
          .where('idSubject', isEqualTo: subjectId)
          .get();

      final List<DocumentSnapshot> documents = snapshot.docs;

      if (documents.isEmpty) {
        await deleteSubjectById(subjectId);
        return left(Failure("No lessons found for the subject"));
      } else {
        for (final DocumentSnapshot document in documents) {
          final String idLesson = document.id;
          developer.log(idLesson);
          await deleteAttendanceByLessonId(idLesson)
              .then((value) => document.reference.delete())
              .then((value) => deleteSubjectById(subjectId));
        }
      }

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureEitherVoid deleteSubjectById(String subjectId) async {
    try {
      final DocumentReference docRef = FirebaseFirestore.instance
          .collection(FirebaseConstants.subjectCollection)
          .doc(subjectId);

      return right(await docRef.delete());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureEitherVoid deleteAttendanceByLessonId(String lessonId) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.attendanceForLessonCollection)
          .where('idLesson', isEqualTo: lessonId)
          .get();

      final List<DocumentSnapshot> documents = snapshot.docs;

      if (documents.isEmpty) {
        return left(Failure("No attendance found for the lesson"));
      }

      for (final DocumentSnapshot document in documents) {
        await document.reference.delete();
      }

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
