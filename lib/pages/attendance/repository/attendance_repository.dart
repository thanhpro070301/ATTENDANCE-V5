import 'package:attendance_/pages/attendance/attendance.dart';
import 'package:attendance_/pages/lesson_class/repository/lesson_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/firebase_constants.dart';
import 'package:attendance_/models/attendance_for_class/attendance_for_class_model.dart';
import 'package:attendance_/models/attendance_for_lesson_model/attendance_model.dart';
import 'package:attendance_/pages/attendance/controller/attendance_controller.dart';
import 'package:attendance_/provider/firebase_provider.dart';

final attendanceRepositoryProvider = Provider.autoDispose((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  final lessonRepository = ref.watch(lessonRepositoryProvider);
  return AttendanceRepository(
    firestore: firestore,
    lessonRepository: lessonRepository,
    ref: ref,
  );
});

abstract class IAttendanceRepository {
  CollectionReference get attendanceForLessonCollection;
  CollectionReference get attendanceForClassCollection;
  CollectionReference get userCollection;
  CollectionReference get lessonsCollection;
  CollectionReference get classCollection;
  FutureEither<String> createAttendanceForLesson({
    required AttendanceModel attendanceModel,
  });
  Future<bool> checkExitsAttendanceForLesson(String idLesson, String uid);
  FutureEitherVoid updateStatusForLesson({
    required String statusAttendance,
    required DateTime timeAttendance,
    required String id,
  });
  Stream<List<AttendanceModel>> getAllAttendanceByStudentId(String uid);
  Stream<List<AttendanceModel>> getAttendanceByIdLesson(String lessonId);
  Future countAttendanceStatus(String idLesson);
  Stream<List<AttendanceModel>> getAttendanceByDate(String uid, String date);
  Stream<int> countAttendanceOfLesson(String idLesson);
  Future<void> attendanceSubjectStatisticsByMonth(
      String idSubject, DateTime dateTime);
  Future<void> attendanceSubjectStatisticsByWeek(
      String idSubject, DateTime dateTime);
  String getStartOfWeek(DateTime dateTime);
  String getEndOfWeek(DateTime dateTime);
  Stream<void> attendanceSubjectStatisticsByYear(
      String idSubject, DateTime dateTime);
  Stream<List<AttendanceModel>> getAllAttendanceBySubjectId(String subjectId);
  Stream<List<AttendanceModel>> findAllAttendanceBySubjectIdAndStudentId(
      AttendanceClassQuery request);
  //* CLASS====================================================================================
  //* CLASS====================================================================================
  //* CLASS====================================================================================
  //* CLASS====================================================================================
  //* CLASS====================================================================================
  //* CLASS====================================================================================
  FutureEitherVoid createAttendanceForClass(
      {required AttendanceForClassModel attendanceModel});
  Future<bool> checkAttendanceStatusInClassOfUser(
      String idUser, String idClass);
  Future<bool> checkAttendanceExistClassOfUser(
      String phoneUser, String idClass);
  Future<bool> checkUserHaveCode(String idStudent);
  Stream<bool> checkAttendanceExistClassOfUserStream(
      String phoneUser, String idClass);
  Stream<List<AttendanceForClassModel>> getAttendanceClassByDate(
      String uid, String date);
  FutureEither<String> updateAttendanceClassByStudentId(
    String studentId,
    String idClass,
    String location,
    String deviceName,
    String codeStudent,
  );
  Future countAttendanceStatusByClass(String idClass);
  Stream<List<AttendanceForClassModel>> getAttendanceByClass(String classId);
  FutureEitherVoid updateStatusForClass({
    required String statusAttendance,
    required DateTime timeAttendance,
    required String id,
  });
  FutureEitherVoid updateAbsentAttendanceByClass(String idClass);
  FutureEitherVoid resetAttendanceByClass(String idClass);
  Future<List<AttendanceForClassModel>> getAttendanceByClassFuture(
      String classId);
  Stream<List<AttendanceForClassModel>> getAttendanceClassByStudentId(
      String uid);
  Stream<List<AttendanceForClassModel>> getAttendanceClassByStudentIdAndClassId(
      AttendanceClassQuery request);
  Stream<List<AttendanceForClassModel>>
      getAttendanceByDateAndClassIdAndStudentId(
          AttendanceByDateAndObjectIdQuery request);
  Stream<List<AttendanceForClassModel>> getAttendanceByNameCreatorClass(
      String userName);
  Stream<List<AttendanceModel>> findAllAttendanceBySubjectIdAndStudentIdAndDate(
      AttendanceByDateAndObjectIdQuery request);
}

class AttendanceRepository implements IAttendanceRepository {
  final FirebaseFirestore _firestore;
  final Ref _ref;
  final LessonRepository _lessonRepository;
  AttendanceRepository({
    required Ref ref,
    required FirebaseFirestore firestore,
    required LessonRepository lessonRepository,
  })  : _firestore = firestore,
        _lessonRepository = lessonRepository,
        _ref = ref;
  @override
  CollectionReference get attendanceForLessonCollection =>
      _firestore.collection(FirebaseConstants.attendanceForLessonCollection);
  @override
  CollectionReference get userCollection =>
      _firestore.collection(FirebaseConstants.usersCollection);

  @override
  CollectionReference get attendanceForClassCollection =>
      _firestore.collection(FirebaseConstants.attendanceForClassCollection);

  @override
  CollectionReference get lessonsCollection =>
      _firestore.collection(FirebaseConstants.lessonsCollection);

  @override
  CollectionReference get classCollection =>
      _firestore.collection(FirebaseConstants.classCollection);

  @override
  FutureEither<String> createAttendanceForLesson({
    required AttendanceModel attendanceModel,
  }) async {
    try {
      final isHaveAttendance = await checkExitsAttendanceForLesson(
          attendanceModel.idLesson, attendanceModel.idStudent);
      DocumentSnapshot classSnapshot =
          await lessonsCollection.doc(attendanceModel.idLesson).get();
      final String endAttendance = classSnapshot['endAttendance'];
      final timeRemaining = await _lessonRepository
          .getEndTimeAttendanceOfLesson(attendanceModel.idLesson);

      if (isHaveAttendance) {
        return right('HaveAttendance');
      } else if (endAttendance == '') {
        return right('NotTimeYetAttendance');
      } else {
        if (timeRemaining > 0) {
          await attendanceForLessonCollection.doc(attendanceModel.id).set(
                attendanceModel.toJson(),
              );
          return right('AttendanceSuccess');
        } else {
          return right('CloseAttendance');
        }
      }
    } on FirebaseException catch (e) {
      return left(Failure("Error Firebase: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<bool> checkExitsAttendanceForLesson(
      String idLesson, String uid) async {
    final attendanceSnapshot = await attendanceForLessonCollection
        .where('idLesson', isEqualTo: idLesson)
        .where('idStudent', isEqualTo: uid)
        .get();

    return attendanceSnapshot.docs.isNotEmpty;
  }

  @override
  FutureEitherVoid updateStatusForLesson({
    required String statusAttendance,
    required DateTime timeAttendance,
    required String id,
  }) async {
    final doc = attendanceForLessonCollection.doc(id);
    DateTime timeAttendance = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(timeAttendance);
    try {
      developer.log('Update đây..');
      return right(await doc.update({
        'statusAttendance': statusAttendance,
        'timeAttendance': formattedTime,
      }));
    } on FirebaseException catch (e) {
      return left(Failure("Error Firebase: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

//

  @override
  Stream<List<AttendanceModel>> getAllAttendanceByStudentId(String uid) {
    return attendanceForLessonCollection
        .where('idStudent', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      final List<AttendanceModel> attendanceList = [];

      for (final DocumentSnapshot document in querySnapshot.docs) {
        final Map<String, dynamic> attendanceData =
            document.data() as Map<String, dynamic>;
        attendanceData['documentId'] = document.id;

        attendanceList.add(AttendanceModel.fromJson(attendanceData));
      }

      return attendanceList;
    });
  }

  @override
  Stream<List<AttendanceModel>> getAllAttendanceBySubjectId(String subjectId) {
    return attendanceForLessonCollection
        .where('idSubject', isEqualTo: subjectId)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      final List<AttendanceModel> attendanceList = [];

      for (final DocumentSnapshot document in querySnapshot.docs) {
        final Map<String, dynamic> attendanceData =
            document.data() as Map<String, dynamic>;
        attendanceData['documentId'] = document.id;

        attendanceList.add(AttendanceModel.fromJson(attendanceData));
      }

      return attendanceList;
    });
  }

  @override
  Stream<List<AttendanceModel>> getAttendanceByIdLesson(String lessonId) {
    return attendanceForLessonCollection
        .where('idLesson', isEqualTo: lessonId)
        .snapshots()
        .map((event) {
      List<AttendanceModel> attendances = [];
      for (var doc in event.docs) {
        attendances
            .add(AttendanceModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      return attendances;
    });
  }

  @override
  Future countAttendanceStatus(String idLesson) async {
    final firestore = FirebaseFirestore.instance;
    final collectionRef =
        firestore.collection(FirebaseConstants.attendanceForLessonCollection);
    developer.log('Process count');
    final querySnapshot =
        await collectionRef.where('idLesson', isEqualTo: idLesson).get();

    int absentCount = 0;
    int presentCount = 0;

    for (var doc in querySnapshot.docs) {
      var statusAttendance = doc.data()['statusAttendance'];
      if (statusAttendance == 'absent') {
        absentCount++;
      } else if (statusAttendance == 'present') {
        presentCount++;
      }
    }
    developer.log('absent: $absentCount');
    developer.log('present: $presentCount');

    final doc = lessonsCollection.doc(idLesson);
    developer.log('Update đây..2');
    return (await doc.update({
      'absent': absentCount,
      'present': presentCount,
    }));
  }

  @override
  Stream<List<AttendanceModel>> getAttendanceByDate(String uid, String date) {
    developer.log(uid);
    return attendanceForLessonCollection
        .where('idStudent', isEqualTo: uid)
        .where('createdAt', isEqualTo: date)
        .snapshots()
        .map((event) {
      List<AttendanceModel> todos = [];
      for (var doc in event.docs) {
        todos.add(AttendanceModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      return todos;
    });
  }

  @override
  Stream<List<AttendanceModel>> findAllAttendanceBySubjectIdAndStudentId(
      AttendanceClassQuery request) {
    return attendanceForLessonCollection
        .where('idStudent', isEqualTo: request.idUser)
        .where('idSubject', isEqualTo: request.idClass)
        .snapshots()
        .map((event) {
      List<AttendanceModel> todos = [];
      for (var doc in event.docs) {
        todos.add(AttendanceModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      return todos;
    });
  }

  @override
  Stream<List<AttendanceModel>> findAllAttendanceBySubjectIdAndStudentIdAndDate(
      AttendanceByDateAndObjectIdQuery request) {
    return attendanceForLessonCollection
        .where('idStudent', isEqualTo: request.idUser)
        .where('idSubject', isEqualTo: request.objectId)
        .where('date', isEqualTo: request.date)
        .snapshots()
        .map((event) {
      List<AttendanceModel> todos = [];
      for (var doc in event.docs) {
        todos.add(AttendanceModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      return todos;
    });
  }

  @override
  Stream<int> countAttendanceOfLesson(String idLesson) {
    return attendanceForLessonCollection
        .where('idLesson', isEqualTo: idLesson)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.length);
  }

  @override
  Future<void> attendanceSubjectStatisticsByMonth(
      String idSubject, DateTime dateTime) async {
    final attendanceQuery = FirebaseFirestore.instance
        .collection(FirebaseConstants.attendanceForLessonCollection)
        .where('createdAt', isGreaterThanOrEqualTo: dateTime);
    final attendanceSnapshot = await attendanceQuery.get();

    int presentCount = 0;
    int absentCount = 0;

    for (var doc in attendanceSnapshot.docs) {
      if (doc.data()['idSubject'] == idSubject) {
        if (doc.data()['statusAttendance'] == 'present') {
          presentCount++;
        } else if (doc.data()['statusAttendance'] == 'absent') {
          absentCount++;
        }
      }
    }

    developer.log('Month: ${dateTime.month}/${dateTime.year}');
    developer.log('Present: $presentCount');
    developer.log('Absent: $absentCount');
  }

  @override
  Future<void> attendanceSubjectStatisticsByWeek(
      String idSubject, DateTime dateTime) async {
    final startOfWeek = getStartOfWeek(dateTime);
    final endOfWeek = getEndOfWeek(dateTime);

    final attendanceQuery = FirebaseFirestore.instance
        .collection(FirebaseConstants.attendanceForLessonCollection)
        .where('createdAt', isGreaterThanOrEqualTo: startOfWeek)
        .where('createdAt', isLessThan: endOfWeek);
    final attendanceSnapshot = await attendanceQuery.get();

    int presentCount = 0;
    int absentCount = 0;

    for (var doc in attendanceSnapshot.docs) {
      if (doc.data()['idSubject'] == idSubject) {
        if (doc.data()['statusAttendance'] == 'present') {
          presentCount++;
        } else if (doc.data()['statusAttendance'] == 'absent') {
          absentCount++;
        }
      }
    }

    developer.log('Month: ${dateTime.month}/${dateTime.year}');
    developer.log('Present: $presentCount');
    developer.log('Absent: $absentCount');
  }

  @override
  String getStartOfWeek(DateTime dateTime) {
    final startOfWeek = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    return DateFormat('dd-MM-yyyy').format(startOfWeek);
  }

  @override
  String getEndOfWeek(DateTime dateTime) {
    final endOfWeek =
        dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    return DateFormat('dd-MM-yyyy').format(endOfWeek);
  }

  @override
  Stream<void> attendanceSubjectStatisticsByYear(
      String idSubject, DateTime dateTime) {
    final startOfYear = DateTime(dateTime.year, 1, 1);
    final endOfYear = DateTime(dateTime.year + 1, 1, 1);

    final attendanceQuery = FirebaseFirestore.instance
        .collection(FirebaseConstants.attendanceForLessonCollection)
        .where('createdAt', isGreaterThanOrEqualTo: startOfYear)
        .where('createdAt', isLessThan: endOfYear);

    return attendanceQuery.snapshots().asyncMap((attendanceSnapshot) {
      int presentCount = 0;
      int absentCount = 0;

      for (var doc in attendanceSnapshot.docs) {
        if (doc.get('idSubject') == idSubject) {
          if (doc.get('statusAttendance') == 'present') {
            presentCount++;
          } else if (doc.get('statusAttendance') == 'absent') {
            absentCount++;
          }
        }
      }

      developer.log('Year: ${dateTime.year}');
      developer.log('Present: $presentCount');
      developer.log('Absent: $absentCount');
    });
  }

  //* CLASS====================================================================================
  //* CLASS====================================================================================
  //* CLASS====================================================================================
  //* CLASS====================================================================================
  //* CLASS====================================================================================
  //* CLASS====================================================================================
  @override
  FutureEitherVoid createAttendanceForClass(
      {required AttendanceForClassModel attendanceModel}) async {
    try {
      await attendanceForClassCollection.doc(attendanceModel.id).set(
            attendanceModel.toJson(),
          );
      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure("Error Firebase: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<bool> checkAttendanceStatusInClassOfUser(
      String idUser, String idClass) async {
    QuerySnapshot snapshot = await attendanceForClassCollection
        .where('idStudent', isEqualTo: idUser)
        .where('idClass', isEqualTo: idClass)
        .get();

    List<QueryDocumentSnapshot> attendanceDocs = snapshot.docs;

    if (attendanceDocs.isEmpty) {
      return false;
    } else {
      for (var attendanceDoc in attendanceDocs) {
        if (attendanceDoc['idStudent'] != idUser ||
            attendanceDoc['idClass'] != idClass) {
          return false;
        }
      }
      return true;
    }
  }

  @override
  Future<bool> checkAttendanceExistClassOfUser(
      String phoneUser, String idClass) async {
    QuerySnapshot snapshot = await attendanceForClassCollection
        .where('phoneStudent', isEqualTo: phoneUser)
        .where('idClass', isEqualTo: idClass)
        .get();

    List<QueryDocumentSnapshot> attendanceDocs = snapshot.docs;

    if (attendanceDocs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> checkUserHaveCode(String idStudent) async {
    QuerySnapshot snapshot =
        await userCollection.where('uid', isEqualTo: idStudent).get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> userDocs =
        snapshot.docs as List<QueryDocumentSnapshot<Map<String, dynamic>>>;

    if (userDocs.first.data()['code'] == "") {
      return false;
    } else {
      return true;
    }
  }

  @override
  Stream<bool> checkAttendanceExistClassOfUserStream(
      String phoneUser, String idClass) {
    return attendanceForClassCollection
        .where('phoneStudent', isEqualTo: phoneUser)
        .where('idClass', isEqualTo: idClass)
        .snapshots()
        .map((snapshot) => snapshot.docs.isEmpty);
  }

  @override
  Stream<List<AttendanceForClassModel>> getAttendanceClassByDate(
      String uid, String date) {
    developer.log(uid);
    return attendanceForClassCollection
        .where('idStudent', isEqualTo: uid)
        .where('createdAt', isEqualTo: date)
        .snapshots()
        .map((event) {
      List<AttendanceForClassModel> todos = [];
      for (var doc in event.docs) {
        todos.add(AttendanceForClassModel.fromJson(
            doc.data() as Map<String, dynamic>));
      }
      return todos;
    });
  }

  @override
  Stream<List<AttendanceForClassModel>>
      getAttendanceByDateAndClassIdAndStudentId(
          AttendanceByDateAndObjectIdQuery request) {
    return attendanceForClassCollection
        .where('idStudent', isEqualTo: request.idUser)
        .where('createdAt', isEqualTo: request.date)
        .where('idClass', isEqualTo: request.objectId)
        .snapshots()
        .map((event) {
      List<AttendanceForClassModel> todos = [];
      for (var doc in event.docs) {
        todos.add(AttendanceForClassModel.fromJson(
            doc.data() as Map<String, dynamic>));
      }
      return todos;
    });
  }

  @override
  Stream<List<AttendanceForClassModel>> getAttendanceClassByStudentId(
      String uid) {
    developer.log(uid);
    return attendanceForClassCollection
        .where('idStudent', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<AttendanceForClassModel> todos = [];
      for (var doc in event.docs) {
        todos.add(AttendanceForClassModel.fromJson(
            doc.data() as Map<String, dynamic>));
      }
      return todos;
    });
  }

  @override
  Stream<List<AttendanceForClassModel>> getAttendanceClassByStudentIdAndClassId(
      AttendanceClassQuery request) {
    return attendanceForClassCollection
        .where('idStudent', isEqualTo: request.idUser)
        .where('idClass', isEqualTo: request.idClass)
        .snapshots()
        .map((event) {
      List<AttendanceForClassModel> todos = [];
      for (var doc in event.docs) {
        todos.add(AttendanceForClassModel.fromJson(
            doc.data() as Map<String, dynamic>));
      }
      return todos;
    });
  }

  @override
  FutureEither<String> updateAttendanceClassByStudentId(
    String studentId,
    String idClass,
    String location,
    String deviceName,
    String codeStudent,
  ) async {
    try {
      String formattedTime = '';
      final now = DateTime.now();
      final Stream<QuerySnapshot> snapshotStreamAttendance =
          attendanceForClassCollection.snapshots();
      DocumentSnapshot classSnapshot = await classCollection.doc(idClass).get();
      final String endAttendance = classSnapshot['endAttendance'];

      DateTime endTime = DateFormat('yyyy-MM-dd HH:mm:ss').parse(endAttendance);
      Duration difference = endTime.difference(now);

      if (difference.inSeconds <= 0) {
        return right('CloseAttendance');
      }
      await for (final QuerySnapshot querySnapshot
          in snapshotStreamAttendance) {
        final List<DocumentSnapshot> documents = querySnapshot.docs;

        for (final DocumentSnapshot document in documents) {
          final String documentId = document.id;
          final String idStudent = document['idStudent'];
          final String classId = document['idClass'];
          final String statusAttendance = document['statusAttendance'];
          final String timeAttendanceDoc = document['timeAttendance'];

          if (idStudent == studentId && idClass == classId) {
            if (statusAttendance == 'present' || statusAttendance == 'absent') {
              return right(timeAttendanceDoc);
            } else {
              if (codeStudent == '') {
                return right('isNotHaveCode');
              }
              formattedTime =
                  DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
              developer.log('Yes, the student has attendance $formattedTime');
              developer.log('Update đây.3.');
              await attendanceForClassCollection.doc(documentId).update({
                'statusAttendance': 'present',
                'timeAttendance': formattedTime,
                'location': location,
                'deviceName': deviceName,
                'code': codeStudent,
              });
              _ref
                  .read(attendanceControllerProvider.notifier)
                  .countAttendanceStatusByClass(classId);
              return right('SuccessAttendance');
            }
          }
        }
      }

      return left(
          Failure("No student found or the student has attendance already"));
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error: $e"));
    } catch (e) {
      developer.log(e.toString());
      return left(Failure(e.toString()));
    }
  }

  @override
  Future countAttendanceStatusByClass(String idClass) async {
    final firestore = FirebaseFirestore.instance;
    final collectionRef =
        firestore.collection(FirebaseConstants.attendanceForClassCollection);
    developer.log('Process count');
    final querySnapshot =
        await collectionRef.where('idClass', isEqualTo: idClass).get();

    int absentCount = 0;
    int presentCount = 0;

    for (var doc in querySnapshot.docs) {
      var statusAttendance = doc.data()['statusAttendance'];
      if (statusAttendance == 'absent') {
        absentCount++;
      } else if (statusAttendance == 'present') {
        presentCount++;
      }
    }

    final doc = classCollection.doc(idClass);

    return (await doc.update({
      'absent': absentCount,
      'present': presentCount,
    }));
  }

  @override
  Stream<List<AttendanceForClassModel>> getAttendanceByClass(String classId) {
    return attendanceForClassCollection
        .where('idClass', isEqualTo: classId)
        .snapshots()
        .map((event) {
      List<AttendanceForClassModel> attendances = [];
      for (var doc in event.docs) {
        attendances.add(AttendanceForClassModel.fromJson(
            doc.data() as Map<String, dynamic>));
      }
      return attendances;
    });
  }

  @override
  Stream<List<AttendanceForClassModel>> getAttendanceByNameCreatorClass(
      String userName) {
    return attendanceForClassCollection
        .where('nameCreatorClass', isEqualTo: userName)
        .snapshots()
        .map((event) {
      List<AttendanceForClassModel> attendances = [];
      for (var doc in event.docs) {
        attendances.add(AttendanceForClassModel.fromJson(
            doc.data() as Map<String, dynamic>));
      }
      return attendances;
    });
  }

  @override
  FutureEitherVoid updateStatusForClass(
      {required String statusAttendance,
      required DateTime timeAttendance,
      required String id}) async {
    final doc = attendanceForClassCollection.doc(id);

    String formattedTime =
        DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());
    try {
      developer.log('Update đây.5.');
      await doc.update({
        'statusAttendance': statusAttendance,
        'timeAttendance': formattedTime,
        'location': 'Admin',
        'deviceName': 'Admin',
      });

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure("Error Firebase: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureEitherVoid updateAbsentAttendanceByClass(String idClass) async {
    try {
      String formattedTime =
          DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now());

      QuerySnapshot querySnapshot = await attendanceForClassCollection.get();
      final List<DocumentSnapshot> documents = querySnapshot.docs;

      for (final DocumentSnapshot document in documents) {
        final String documentId = document.id;
        final String classId = document['idClass'];
        final String statusAttendance = document['statusAttendance'];

        if (idClass == classId) {
          developer.log('Update đây..6');
          if (statusAttendance == '' || statusAttendance == 'noAttendance') {
            await attendanceForClassCollection.doc(documentId).update({
              'statusAttendance': 'absent',
              'timeAttendance': formattedTime,
              'deviceName': 'null',
              'location': 'null',
            });
          }
        }
      }
      _ref
          .read(attendanceControllerProvider.notifier)
          .countAttendanceStatusByClass(idClass);
      // _ref
      //     .read(historyAttendanceOfClassControllerProvider.notifier)
      //     .createHistoryAttendanceByClass(idClass: idClass);

      _ref.read(isAttendanceClassProvider.notifier).update((state) => null);
      return left(
          Failure("No student found or the student has attendance already"));
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureEitherVoid resetAttendanceByClass(String idClass) async {
    try {
      final QuerySnapshot querySnapshot =
          await attendanceForClassCollection.get();
      final List<DocumentSnapshot> documents = querySnapshot.docs;
      final docClass = classCollection.doc(idClass);

      await docClass.update({'endAttendance': ''});

      for (final DocumentSnapshot document in documents) {
        final String documentId = document.id;
        final String classId = document['idClass'];
        final String statusAttendance = document['statusAttendance'];

        if (idClass == classId) {
          if (statusAttendance == 'absent' || statusAttendance == 'present') {
            await attendanceForClassCollection.doc(documentId).update({
              'statusAttendance': '',
              'timeAttendance': '',
            });
            //
          }
        }
        _ref
            .read(attendanceControllerProvider.notifier)
            .countAttendanceStatusByClass(idClass);
      }

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<List<AttendanceForClassModel>> getAttendanceByClassFuture(
      String classId) async {
    final snapshot = await attendanceForClassCollection
        .where('idClass', isEqualTo: classId)
        .get();

    final attendances = snapshot.docs
        .map((doc) => AttendanceForClassModel.fromJson(
            doc.data() as Map<String, dynamic>))
        .toList();

    return attendances;
  }
}
