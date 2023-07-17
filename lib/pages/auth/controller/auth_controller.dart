import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'
    as snack;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/app_home_chatscreen/app_home_screen.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/auth/repository/auth_repository.dart';
import 'package:attendance_/pages/welcome/welcome_screen.dart';

final isLoadingLoginProvider = StateProvider((ref) => false);
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    return AuthController(
      authRepository: authRepository,
      ref: ref,
    );
  },
);

final searchUserDataProvider = StreamProvider.family(
  (ref, String query) {
    final authProvider = ref.watch(authControllerProvider.notifier);
    return authProvider.searchUserData(query);
  },
);

final userDataAuthProvider = FutureProvider(
  (ref) {
    final authProvider = ref.watch(authControllerProvider.notifier);
    return authProvider.getUserData();
  },
);

final getUserDataByIdProvider = StreamProvider.family(
  (ref, String userId) {
    final authProvider = ref.watch(authControllerProvider.notifier);
    return authProvider.userDataById(userId);
  },
);

// final getStudentsProvider = FutureProvider.family(
//   (ref, BuildContext context) {
//     final authController = ref.watch(authControllerProvider.notifier);
//     return authController.getStudents(context);
//   },
// );

final getUserDataByPhoneProvider = StreamProvider.family(
  (ref, String phoneNumber) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.getUserDataByPhone(phoneNumber);
  },
);

final getUserDataByPhoneFutureProvider = FutureProvider.family(
  (ref, String phoneNumber) {
    final authController = ref.watch(authControllerProvider.notifier);
    return authController.getUserDataByPhoneFuture(phoneNumber);
  },
);

final authStateChangeProvider = StreamProvider(
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
    await _authRepository.signInWithPhone(context, phoneNumber);
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

  void saveUserDataToFirebase({
    required String name,
    required BuildContext context,
    required File? profilePic,
    required String email,
  }) async {
    state = true;
    final res = await _authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic, email: email);
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

  void getStudents(BuildContext context) async {
    await _authRepository.getStudents(context);
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

  Stream<UserModel> getUserDataByPhone(String phoneNumber) {
    return _authRepository.getUserDataByPhone(phoneNumber);
  }

  Future<UserModel> getUserDataByPhoneFuture(String phoneNumber) async {
    return await _authRepository.getUserDataByPhoneFuture(phoneNumber);
  }

  Stream<List<UserModel>> searchUserData(String query) {
    return _authRepository.searchUserData(query);
  }
}
