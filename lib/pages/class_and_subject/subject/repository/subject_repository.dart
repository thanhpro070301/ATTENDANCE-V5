import 'package:attendance_/models/attendance_for_lesson_model/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/firebase_constants.dart';
import 'package:attendance_/models/subjects_model/subject_model.dart';
import 'package:attendance_/provider/firebase_provider.dart';
import 'dart:developer' as developer;

final subjectRepositoryProvider = Provider(
  (ref) {
    final firestore = ref.watch(firebaseFirestoreProvider);
    return SubjectRepository(firestore: firestore);
  },
);

abstract class ISubjectRepository {
  CollectionReference get subjectCollection;
  CollectionReference get attendanceForLessonCollection;
  FutureEitherVoid createSubject(SubjectModel subjectModel);
  FutureEitherVoid updateSubject({
    required SubjectModel subjectModel,
    required String id,
  });

  FutureEitherVoid updateLessonForSubject(
      {required String idSubject, required String idLesson});

  Stream<List<SubjectModel>> getSubjects(String uid);

  Stream<SubjectModel?> getSubjectById(String idSubject);

  Stream<int> countLessons(String idSubject);

  Future<SubjectModel?> getSubjectByIdLesson(String idLesson);

  Stream<List<AttendanceModel>> getAttendanceByLessonUseIdSubject(
      String idSubject);
}

class SubjectRepository implements ISubjectRepository {
  final FirebaseFirestore _firestore;
  SubjectRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  @override
  CollectionReference get subjectCollection =>
      _firestore.collection(FirebaseConstants.subjectCollection);

  @override
  CollectionReference get attendanceForLessonCollection =>
      _firestore.collection(FirebaseConstants.attendanceForLessonCollection);

  @override
  FutureEitherVoid createSubject(SubjectModel subjectModel) async {
    try {
      return right(await subjectCollection
          .doc(subjectModel.id)
          .set(subjectModel.toJson()));
    } on FirebaseException catch (e) {
      return left(Failure("Error Firebase: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureEitherVoid updateSubject(
      {required SubjectModel subjectModel, required String id}) async {
    final subject = subjectCollection.doc(id);
    try {
      return right(await subject.update(subjectModel.toJson()));
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureEitherVoid updateLessonForSubject(
      {required String idSubject, required String idLesson}) async {
    final subject = subjectCollection.doc(idSubject);
    try {
      final existingData = await subject.get();
      final existingLessons = List<String>.from(
          (existingData.data() as Map<String, dynamic>)['lessons'] ?? []);
      existingLessons.add(idLesson);
      developer.log('Update lesson đây..');
      await subject.update({'lessons': existingLessons});
      developer.log("Process update lesson for class");
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<SubjectModel>> getSubjects(String uid) {
    return subjectCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<SubjectModel> subjects = [];
      for (var doc in event.docs) {
        subjects.add(SubjectModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      return subjects;
    });
  }

  @override
  Stream<SubjectModel?> getSubjectById(String idSubject) {
    return subjectCollection.doc(idSubject).snapshots().map(
        (event) => SubjectModel.fromJson(event.data() as Map<String, dynamic>));
  }

  @override
  Stream<int> countLessons(String idSubject) {
    final CollectionReference subjectRef = FirebaseFirestore.instance
        .collection(FirebaseConstants.subjectCollection);

    try {
      return subjectRef.doc(idSubject).snapshots().map((subjectDoc) {
        developer.log("ID subject $idSubject");

        if (subjectDoc.exists) {
          final Map<String, dynamic>? data =
              subjectDoc.data() as Map<String, dynamic>?;

          if (data != null) {
            final List<dynamic>? lessons = data['lessons'];

            developer.log("ID subject ${lessons!.length}");
            return lessons.length;
          }
        }

        return 0;
      });
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }

  Future<int> countLessonsFuture(String idSubject) async {
    final DocumentReference subjectRef = FirebaseFirestore.instance
        .collection(FirebaseConstants.subjectCollection)
        .doc(idSubject);

    try {
      final DocumentSnapshot subjectDoc = await subjectRef.get();
      developer.log("ID subject $idSubject");

      if (subjectDoc.exists) {
        final Map<String, dynamic>? data =
            subjectDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          final List<dynamic>? lessons = data['lessons'];

          developer.log("ID subject ${lessons!.length}");
          return lessons.length;
        }
      }
    } catch (e) {
      developer.log('Error: $e');
    }

    return 0;
  }

  @override
  @override
  Future<SubjectModel?> getSubjectByIdLesson(String idLesson) async {
    final querySnapshot = await subjectCollection.get();

    for (final doc in querySnapshot.docs) {
      final lessons = doc.get('lessons') as List<dynamic>;
      if (lessons.contains(idLesson)) {
        return SubjectModel.fromJson(doc.data() as Map<String, dynamic>);
      }
    }

    return null;
  }

  @override
  Stream<List<AttendanceModel>> getAttendanceByLessonUseIdSubject(
      String idSubject) {
    try {
      return attendanceForLessonCollection
          .where('idSubject', isEqualTo: idSubject)
          .snapshots()
          .map((event) {
        List<AttendanceModel> attendances = [];

        for (var doc in event.docs) {
          AttendanceModel attendance =
              AttendanceModel.fromJson(doc.data() as Map<String, dynamic>);
          attendances.add(attendance);
        }

        return attendances;
      });
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      rethrow;
    } catch (e) {
      developer.log(e.toString());
      rethrow;
    }
  }
}
