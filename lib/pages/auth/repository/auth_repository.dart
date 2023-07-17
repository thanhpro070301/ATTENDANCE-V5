import 'dart:async';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:attendance_/common/values/constants.dart';
import 'package:attendance_/common/values/save_read_excel.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/common/values/firebase_constants.dart';
import 'package:attendance_/common/values/theme.dart';

import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/app_home_chatscreen/app_home_screen.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/otp_phone/otp_screen.dart';
import 'package:attendance_/pages/user_information/user_information.dart';
import 'package:attendance_/provider/firebase_provider.dart';
import 'package:attendance_/provider/storage_repository.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';
import 'package:quickalert/quickalert.dart';
import 'package:sms_autofill/sms_autofill.dart';

final verificationIdProvider = StateProvider((ref) => '');
final resendTokenProvider = StateProvider((ref) => 0);
final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref: ref,
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firebaseFirestore: ref.watch(firebaseFirestoreProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
  ),
);

final getUserByIdProvider = StreamProvider.family((ref, String uid) {
  final authProvider = ref.watch(authControllerProvider.notifier);
  return authProvider.userDataById(uid);
});

abstract class IAuthRepository {
  Future<UserModel?> getCurrentUserData();
  FutureEither<bool> signInWithPhone(BuildContext context, String phoneNumber);
  FutureEitherVoid verifyOTP({
    required String verificationId,
    required String userOTP,
    required BuildContext context,
  });
  FutureEitherVoid saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required String email,
  });
  void logOut();
  Stream<UserModel> userData(String userId);
  Stream<UserModel> getUserDataByPhone(String phoneNumber);
  Future<UserModel> getUserDataByPhoneFuture(String phoneNumber);
  void setUserState(bool isOnline, String uid);
  Future<void> getStudents(BuildContext context);
  Future<bool> checkExistingUser();
  Stream<List<UserModel>> searchUserData(String query);

  // Future<List<UserModel>> getStudents(BuildContext context);
}

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  final StorageRepository _storageRepository;
  final Ref _ref;
  const AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _storageRepository = storageRepository,
        _ref = ref,
        super();

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();
  CollectionReference get _user =>
      _firebaseFirestore.collection(FirebaseConstants.usersCollection);

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      var userData = await _firebaseFirestore
          .collection(FirebaseConstants.usersCollection)
          .doc(_firebaseAuth.currentUser?.uid)
          .get();
      UserModel? user;
      if (userData.data() != null) {
        user = UserModel.fromJson(userData.data()!);
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  FutureEither<bool> signInWithPhone(
      BuildContext context, String phoneNumber) async {
    try {
      _ref.read(isLoadingLoginProvider.notifier).update((state) => true);
      await Future.delayed(const Duration(milliseconds: 1800));
      await _firebaseAuth.verifyPhoneNumber(
        timeout: const Duration(seconds: 30),
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          _ref
              .read(pinControllerProvider)
              .setText(phoneAuthCredential.smsCode!);
          developer.log('${_ref.read(pinControllerProvider)}');

          String? otp = await SmsAutoFill().getAppSignature;
          debugPrint(otp);
          // _ref.read(pinControllerProvider).setText(otp);
        },
        verificationFailed: (error) {
          developer.log(error.code);
          if (error.code == 'invalid-phone-number' || error.code == 'unknown') {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              title: 'Lỗi...',
              confirmBtnText: 'Đồng ý',
              confirmBtnColor: AppTheme.nearlyDarkBlue,
              text:
                  'Số điện thoại mà bạn nhập không hợp lệ. Vui lòng nhập lại.',
            );
          } else if (error.code == 'app-not-authorized') {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.info,
              title: 'Ô có một vấn đề nhỏ...',
              confirmBtnText: 'Đồng ý',
              confirmBtnColor: AppTheme.nearlyDarkYellow,
              text:
                  'Ứng dụng chưa được xác thực. Vui lòng đăng nhập hoặc cấp quyền truy cập trên Firebase.',
            );
          } else if (error.code == 'too-many-requests') {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.info,
                title: 'Ô có một vấn đề nhỏ...',
                confirmBtnText: 'Đồng ý',
                confirmBtnColor: AppTheme.nearlyDarkYellow,
                text: "Yêu cầu quá nhiều. Vui lòng thử lại sau ít phút nữa.");
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Lỗi...',
              confirmBtnText: 'Đồng ý',
              confirmBtnColor: AppTheme.nearlyDarkBlue,
              text: error.toString(),
            );
          }
        },
        codeSent: (verificationId, forceResendingToken) async {
          Navigator.push(
            context,
            PageTransition(
              curve: Curves.elasticInOut,
              type: PageTransitionType.leftToRightWithFade,
              child: OTPScreen(verificationId: verificationId),
            ),
          );
          _ref.read(verificationIdProvider.notifier).state = verificationId;
          _ref.read(resendTokenProvider.notifier).state =
              forceResendingToken ?? 0;
          print(_ref.read(resendTokenProvider));
        },
        forceResendingToken: _ref.read(resendTokenProvider),
        codeAutoRetrievalTimeout: (verificationId) {
          verificationId = _ref.read(verificationIdProvider);
        },
      );
      debugPrint("_verificationId: ${_ref.read(verificationIdProvider)}");
      return right(true);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(
        e.toString(),
      ));
    } finally {
      _ref.read(isLoadingLoginProvider.notifier).update((state) => false);
    }
  }

  @override
  FutureEitherVoid verifyOTP({
    required String verificationId,
    required String userOTP,
    required BuildContext context,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);

      await _firebaseAuth.signInWithCredential(credential);
      final existUser = await checkExistingUser();
      if (existUser) {
        final currentUser = await getCurrentUserData();
        _ref.read(userProvider.notifier).update((state) => currentUser);
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppHomeScreen.routeName,
            (route) => false,
          );
        }
      } else {
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            UserInformationScreen.routeName,
            (route) => false,
          );
        }
      }
      return right(null);
    } on FirebaseAuthException catch (e) {
      developer.log(e.code);
      if (e.code == 'unknown' || e.code == 'invalid-verification-code') {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Lỗi...',
            confirmBtnText: 'Đồng ý',
            confirmBtnColor: AppTheme.nearlyDarkBlue,
            text:
                'Mã xác thực từ SMS/TOTP không hợp lệ. Vui lòng kiểm tra và nhập lại mã xác thực chính xác.');
      } else {
        developer.log(e.code);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Lỗi...',
          confirmBtnText: 'Đồng ý',
          confirmBtnColor: AppTheme.nearlyDarkBlue,
          text: e.message!,
        );
      }
      return left(Failure(e.toString()));
    } catch (e) {
      developer.log(e.toString());
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Lỗi...',
        confirmBtnText: 'Đồng ý',
        confirmBtnColor: AppTheme.nearlyDarkBlue,
        text: e.toString(),
      );
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<UserModel>> searchUserData(String query) {
    return _user.snapshots().map((event) {
      List<UserModel> users = [];
      for (var user in event.docs) {
        var data = user.data() as Map<String, dynamic>;
        var name = data['name'] as String;
        if (name.toLowerCase().contains(query.toLowerCase())) {
          users.add(UserModel.fromJson(user.data() as Map<String, dynamic>));
        }
      }
      return users;
    });
  }

  @override
  FutureEitherVoid saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required String email}) async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      String photoUrl =
          'https://phongreviews.com/wp-content/uploads/2022/11/avatar-facebook-mac-dinh-8.jpg';
      if (profilePic != null) {
        photoUrl = await _storageRepository.storeFileStorage(
          "profilePic/$uid",
          profilePic,
        );
      }
      String dateNow = formatDate(DateTime.now());
      var user = UserModel(
        uid: uid,
        name: name,
        profilePic: photoUrl,
        email: email,
        code: '',
        updatedAt: dateNow,
        banner: ConstantsController.bannerDefault,
        createdAt: DateTime.now(),
        groupId: [],
        phoneNumber: _firebaseAuth.currentUser!.phoneNumber!,
        isOnline: true,
      );

      return right(
        await _firebaseFirestore
            .collection(FirebaseConstants.usersCollection)
            .doc(uid)
            .set(
              user.toJson(),
            ),
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  void logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<UserModel> userData(String userId) {
    return _firebaseFirestore
        .collection(FirebaseConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map(
          (event) => UserModel.fromJson(event.data()!),
        );
  }

  @override
  Stream<UserModel> getUserDataByPhone(String phoneNumber) {
    return _firebaseFirestore
        .collection(FirebaseConstants.usersCollection)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first.data();
        final userModel = UserModel.fromJson(userData);
        return userModel;
      } else {
        throw Exception("User not found");
      }
    });
  }

  @override
  Future<UserModel> getUserDataByPhoneFuture(String phoneNumber) async {
    final snapshot = await _firebaseFirestore
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
  void setUserState(bool isOnline, String uid) async {
    developer.log('Update online đây..');
    return await _firebaseFirestore
        .collection(FirebaseConstants.usersCollection)
        .doc(uid)
        .update({'isOnline': isOnline});
  }

  @override
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    if (snapshot.exists) {
      developer.log("USER EXIST");
      return true;
    } else {
      developer.log("NEW USER");
      return false;
    }
  }

  @override
  Future<void> getStudents(BuildContext context) async {
    Set<UserModel> students = {};

    await for (var event in _user.snapshots()) {
      for (var doc in event.docs) {
        students.add(UserModel.fromJson(doc.data() as Map<String, dynamic>));
      }
      if (students.isNotEmpty) {
        for (var student in students) {
          testDataImport.add({
            "name": student.name,
            "phoneNumber": student.phoneNumber,
          });
          testDataList = testDataImport.toList();
        }
      }
    }
  }
}
