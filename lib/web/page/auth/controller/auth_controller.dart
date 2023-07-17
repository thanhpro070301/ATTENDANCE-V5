import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snack;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/welcome/welcome_screen.dart';

import '../../../../pages/app_home_chatscreen/app_home_screen.dart';
import '../provider/auth_provider.dart';
import '../repository/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, bool>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthController(
      authRepository: authRepository,
      ref: ref,
    );
  },
);

final userDataAuthProvider = FutureProvider.autoDispose(
  (ref) {
    final authProvider = ref.watch(authControllerProvider.notifier);
    return authProvider.getUserData();
  },
);

final getUserDataById = StreamProvider.autoDispose.family(
  (ref, String userId) {
    final authProvider = ref.watch(authControllerProvider.notifier);
    return authProvider.userDataById(userId);
  },
);

final getStudents = StreamProvider.autoDispose(
  (ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.getStudents();
  },
);

final getStudentsByClass = StreamProvider.autoDispose.family(
  (ref, String classNameStudy) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.getStudentsByClass(classNameStudy);
  },
);

final getUserDataByPhoneProvider = StreamProvider.autoDispose.family(
  (ref, String phoneNumber) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.getUserDataByPhone(phoneNumber);
  },
);

final getUserDataByPhoneFutureProvider = FutureProvider.autoDispose.family(
  (ref, String phoneNumber) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.getUserDataByPhoneFuture(phoneNumber);
  },
);

final authStateChangeProvider = StreamProvider.autoDispose(
  (ref) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.authStateChange;
  },
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);
  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Future<UserModel?> getUserData() async {
    UserModel? user = await _authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    state = true;
    await _authRepository.signInWithPhone(context, phoneNumber);
    state = false;
  }

  void verify({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    state = true;
    await _authRepository.verifyOTP(
      context: context,
      userOTP: userOTP,
      verificationId: verificationId,
    );
    state = false;
  }

  void saveUserDataToFirebase(
      {required String name,
      required BuildContext context,
      required File? profilePic}) async {
    state = true;
    final res = await _authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic);
    state = false;
    UserModel? userModel;
    res.fold(
        (l) => showSnackBarCustom(
            context, snack.ContentType.failure, 'Oh Snap!', l.message),
        (r) async {
      userModel =
          await _ref.read(authControllerProvider.notifier).getUserData();

      _ref.read(userProvider.notifier).update((state) => userModel);
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AppHomeScreen()),
            (route) => false);
      }
    });
  }

  Stream<List<UserModel>> getStudents() {
    return _authRepository.getStudents();
  }

  void logout(BuildContext context) async {
    _authRepository.logOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      WelcomeScreen.routeName,
      (route) => false,
    );
  }

  Stream<UserModel> userDataById(String userId) {
    return _authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    final uid = _ref.read(userProvider)!.uid;
    return _authRepository.setUserState(isOnline, uid);
  }

  Stream<List<UserModel>> getStudentsByClass(String classNameStudy) {
    return _authRepository.getStudentsByClass(classNameStudy);
  }

  Stream<UserModel> getUserDataByPhone(String phoneNumber) {
    return _authRepository.getUserDataByPhone(phoneNumber);
  }

  Future<UserModel> getUserDataByPhoneFuture(String phoneNumber) async {
    return await _authRepository.getUserDataByPhoneFuture(phoneNumber);
  }
}
