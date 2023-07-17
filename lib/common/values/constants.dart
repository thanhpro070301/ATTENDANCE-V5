// ignore_for_file: constant_identifier_names

import 'package:attendance_/pages/app_home_chatscreen/mobile_layout_screen.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';

import 'package:attendance_/pages/class_and_subject/subject_screen.dart';
import 'package:attendance_/pages/details_subject_and_class/details_subject_and_class.dart';
import 'package:attendance_/pages/home/home_screen.dart';
import 'package:attendance_/pages/lessons_attendance_for_student/lessons_for_student.dart';

import 'package:attendance_/pages/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final constantControllerProvider =
    StateNotifierProvider<ConstantsController, bool>((ref) {
  return ConstantsController(ref: ref);
});

class ConstantsController extends StateNotifier<bool> {
  final Ref _ref;

  ConstantsController({required Ref ref})
      : _ref = ref,
        super(false) {
    final uid = _ref.read(userProvider)!.uid;
    tabWidgets = [
      const HomeScreen(),
      const DetailsClassScreen(
        idSubject: '',
        nameSubject: '',
      ),
      const Subject(),
      const LessonAttendanceForStudent(),
      const MobileLayoutScreen(),
      UserProfile(uid: uid),
    ];
  }

  static const bannerDefault =
      'https://images.unsplash.com/photo-1546587348-d12660c30c50?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=874&q=80';
  static const String STORAGE_DEVICE_OPEN_FIRST_TIME = 'device_first_open';
  static const String STORAGE_USER_PROFILE_KEY = 'user_profile_key';
  static const String STORAGE_USER_TOKEN_KEY = 'user_token_key';

  List<Widget> tabWidgets = [];

  List<Widget> getTabWidgets() => tabWidgets;
}
