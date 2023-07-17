import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/firebase_constants.dart';
import 'package:attendance_/models/class_model/class_model.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/provider/firebase_provider.dart';
import 'dart:developer' as developer;

final classRepositoryProvider = Provider.autoDispose(
  (ref) {
    final firestore = ref.watch(firebaseFirestoreProvider);

    return ClassRepository(
      firestore: firestore,
    );
  },
);

abstract class IClassRepository {
  CollectionReference get classCollection;
  CollectionReference get users;
  CollectionReference get attendanceForClassCollection;

  FutureEitherVoid createClass(ClassModel classModel);
  Stream<List<ClassModel>> getClasses(String uid);
  Stream<List<String>> getUserPhonesOfClass(String idClass);
  Stream<ClassModel?> getClassById(String idClass);
  Future<ClassModel?> getClassByIdFuture(String idClass);
  Future<List<String>> getUserPhonesOfClassCheckExitsFuture(String idClass);
  Future<List<String>> getUserPhonesOfClassNoCheckExitsFuture(String idClass);
  Future<bool> checkPhoneExistsInUsers(String phone);
  Future<UserModel> getUserDataByPhoneFuture(String phoneNumber);
  Future<bool> checkUserExisting(String phoneNumber);
  Future<List<ClassModel>> checkUserExistInClass(String userPhone);
  FutureEitherVoid updateEndAttendanceForClass({required String idClass});
  FutureEither<int> getEndTimeAttendanceOfClass(String idClass);
  FutureEitherVoid addStudentForClass({
    required String idClass,
    required List<String> listUserPhone,
  });
  Stream<List<String>> getNonExistingUserPhonesStream(String idClass);
  FutureEitherVoid deleteAttendanceByClassId(String lessonId);
  FutureEitherVoid deleteClassById(String classId);
}

class ClassRepository implements IClassRepository {
  final FirebaseFirestore _firestore;

  ClassRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  CollectionReference get classCollection =>
      _firestore.collection(FirebaseConstants.classCollection);

  @override
  CollectionReference get users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  @override
  CollectionReference get attendanceForClassCollection =>
      _firestore.collection(FirebaseConstants.attendanceForClassCollection);
//Class

  @override
  FutureEitherVoid createClass(ClassModel classModel) async {
    try {
      return right(
          await classCollection.doc(classModel.id).set(classModel.toJson()));
    } on FirebaseException catch (e) {
      return left(Failure("Error Firebase: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<ClassModel>> getClasses(String uid) {
    return classCollection
        .where('uidCreator', isEqualTo: uid)
        .snapshots()
        .map((event) {
      List<ClassModel> classes = [];
      for (var doc in event.docs) {
        classes.add(ClassModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      return classes;
    });
  }

  @override
  Stream<List<String>> getUserPhonesOfClass(String idClass) {
    return classCollection.doc(idClass).snapshots().map((snapshot) {
      List<String> phoneList = [];

      if (snapshot.exists) {
        List<dynamic> phones =
            (snapshot.data() as Map<String, dynamic>)['listUserPhone'];

        for (var phone in phones) {
          phoneList.add(phone);
        }
      }

      return phoneList;
    });
  }

  @override
  Stream<ClassModel?> getClassById(String idClass) {
    return classCollection.doc(idClass).snapshots().map(
        (event) => ClassModel.fromJson(event.data() as Map<String, dynamic>));
  }

  @override
  Future<ClassModel?> getClassByIdFuture(String idClass) async {
    final snapshot = await classCollection.doc(idClass).get();

    if (snapshot.exists) {
      final classData = snapshot.data() as Map<String, dynamic>;
      final classModel = ClassModel.fromJson(classData);
      return classModel;
    } else {
      return null;
    }
  }

  @override
  Future<List<String>> getUserPhonesOfClassCheckExitsFuture(
      String idClass) async {
    final snapshot = await classCollection.doc(idClass).get();
    List<String> phoneList = [];

    if (snapshot.exists) {
      List<dynamic> phones =
          (snapshot.data() as Map<String, dynamic>)['listUserPhone'];

      for (var phone in phones) {
        bool phoneExists = await checkPhoneExistsInUsers(phone);
        if (phoneExists) {
          phoneList.add(phone);
        }
      }
    }

    developer.log(phoneList.toString());
    return phoneList;
  }

  @override
  Future<List<String>> getUserPhonesOfClassNoCheckExitsFuture(
      String idClass) async {
    final snapshot = await classCollection.doc(idClass).get();
    List<String> phoneList = [];

    if (snapshot.exists) {
      List<dynamic> phones =
          (snapshot.data() as Map<String, dynamic>)['listUserPhone'];

      for (var phone in phones) {
        phoneList.add(phone);
      }
    }

    developer.log(phoneList.toString());
    return phoneList;
  }

  @override
  Future<bool> checkPhoneExistsInUsers(String phone) async {
    final querySnapshot =
        await users.where('phoneNumber', isEqualTo: phone).get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  Future<UserModel> getUserDataByPhoneFuture(String phoneNumber) async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final userData = snapshot.docs.first.data();
      final userModel = UserModel.fromJson(userData);
      return userModel;
    } else {
      throw Exception("User not found");
    }
  }

  @override
  Future<bool> checkUserExisting(String phoneNumber) async {
    final snapshot = await _firestore
        .collection(FirebaseConstants.usersCollection)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<List<ClassModel>> checkUserExistInClass(String userPhone) async {
    List<ClassModel> userClasses = [];
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(FirebaseConstants.classCollection)
        .get();
    List<QueryDocumentSnapshot> classDocs = snapshot.docs;

    for (var classDoc in classDocs) {
      List<String> phones = List<String>.from(classDoc['listUserPhone']);

      if (phones.contains(userPhone)) {
        userClasses
            .add(ClassModel.fromJson(classDoc.data() as Map<String, dynamic>));
      }
    }

    return userClasses;
  }

  @override
  FutureEitherVoid updateEndAttendanceForClass(
      {required String idClass}) async {
    final classDoc = classCollection.doc(idClass);

    DateTime now = DateTime.now();
    DateTime endTime = now.add(const Duration(seconds: 90));

    String endTimeStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(endTime);
    developer.log(endTimeStr);
    try {
      developer.log('Update endAtt đây..');

      await classDoc.update({
        'endAttendance': endTimeStr,
      });

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureEither<int> getEndTimeAttendanceOfClass(String idClass) async {
    try {
      DateTime now = DateTime.now();
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.classCollection)
          .doc(idClass)
          .get();
      String endAttendanceString = snapshot['endAttendance'];
      DateTime endTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').parse(endAttendanceString);
      Duration difference = endTime.difference(now);

      if (difference.inSeconds < 0) {
        return right(0);
      }
      return right(difference.inSeconds);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureEitherVoid addStudentForClass(
      {required String idClass, required List<String> listUserPhone}) async {
    final classes = classCollection.doc(idClass);
    try {
      final existingData = await classes.get();
      final existingUserPhone = Set<String>.from(
          (existingData.data() as Map<String, dynamic>)['listUserPhone'] ?? []);

      for (int i = 0; i < listUserPhone.length; i++) {
        final userPhones = listUserPhone[i].split(",");
        for (int j = 0; j < userPhones.length; j++) {
          existingUserPhone.add(userPhones[j]);
        }
      }

      return right(
          await classes.update({'listUserPhone': existingUserPhone.toList()}));
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<String>> getNonExistingUserPhonesStream(String idClass) {
    return classCollection
        .doc(idClass)
        .snapshots()
        .asyncMap((existingData) async {
      final existingUserPhone = Set<String>.from(
          (existingData.data() as Map<String, dynamic>)['listUserPhone'] ?? []);

      final List<String> existingUserPhoneList = existingUserPhone.toList();

      final List<String> nonExistingUserPhones = [];

      for (int i = 0; i < existingUserPhoneList.length; i += 10) {
        final int end = (i + 10 < existingUserPhoneList.length)
            ? i + 10
            : existingUserPhoneList.length;

        final List<String> batch = existingUserPhoneList.sublist(i, end);

        final QuerySnapshot attendanceSnapshot =
            await attendanceForClassCollection
                .where('phoneStudent', whereIn: batch)
                .get();

        final List<QueryDocumentSnapshot> attendanceDocs =
            attendanceSnapshot.docs;
        final Set<String> existingAttendancePhone = Set<String>.from(
            attendanceDocs.map((doc) => doc['phoneStudent'] as String));

        nonExistingUserPhones.addAll(
            batch.where((phone) => !existingAttendancePhone.contains(phone)));
      }

      return nonExistingUserPhones;
    });
  }

  @override
  FutureEitherVoid deleteAttendanceByClassId(String idClass) async {
    try {
      final WriteBatch batch = FirebaseFirestore.instance.batch();

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(FirebaseConstants.attendanceForClassCollection)
          .where('idClass', isEqualTo: idClass)
          .get();

      final List<DocumentSnapshot> documents = snapshot.docs;

      if (documents.isEmpty) {
        await deleteClassById(idClass);
        return left(
            Failure("No attendance found for the class, delete class success"));
      } else {
        for (final DocumentSnapshot document in documents) {
          batch.delete(document.reference);
        }
        await batch.commit();
        await deleteClassById(idClass);
      }

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure("Firebase Error: $e"));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  FutureEitherVoid deleteClassById(String classId) async {
    try {
      final DocumentReference classRef = FirebaseFirestore.instance
          .collection(FirebaseConstants.classCollection)
          .doc(classId);

      final WriteBatch batch = FirebaseFirestore.instance.batch();

      batch.delete(classRef);

      await batch.commit();

      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
