import 'dart:io';
import 'package:attendance_/common/utils.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/user_profile/repository/user_profile_repository.dart';
import 'package:attendance_/provider/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileControllerProvider =
    StateNotifierProvider.autoDispose<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    ref: ref,
    storageRepository: storageRepository,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;
  UserProfileController({
    required StorageRepository storageRepository,
    required UserProfileRepository userProfileRepository,
    required Ref ref,
  })  : _userProfileRepository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void editUserProfile({
    required BuildContext context,
    required File? profileFile,
    required File? bannerFile,
    required String name,
    required String code,
    required String email,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      //communities/profile/meme  if (profilePic != null) {
      final profilePic = await _storageRepository.storeFileStorage(
        "profilePic/${user.uid}",
        profileFile,
      );
      user = user.copyWith(profilePic: profilePic);
    }

    if (bannerFile != null) {
      //communities/banner/meme
      final bannerFilePic = await _storageRepository.storeFileStorage(
        "bannerPic/${user.uid}",
        bannerFile,
      );
      user = user.copyWith(banner: bannerFilePic);
    }
    String dateNow = formatDate(DateTime.now());
    user =
        user.copyWith(name: name, email: email, code: code, updatedAt: dateNow);
    final res = await _userProfileRepository.editUserProfile(user);
    state = false;
    res.fold((l) {}, (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Navigator.of(context).pop();
    });
  }
}
