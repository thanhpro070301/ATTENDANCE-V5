import 'package:attendance_/pages/app_home_chatscreen/mobile_layout_screen.dart';
import 'package:attendance_/pages/qr_app/display_qr/display_qr_screen.dart';
import 'package:attendance_/pages/user_profile/edit_profile.dart';
import 'package:attendance_/pages/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/pages/app_home_chatscreen/app_home_screen.dart';
import 'package:attendance_/pages/attendance/attendance.dart';
import 'package:attendance_/pages/auth/verification_confirmation.dart';
import 'package:attendance_/pages/chat/screens/mobile_chat_screen.dart';
import 'package:attendance_/pages/details_subject_and_class/details_subject_and_class.dart';
import 'package:attendance_/pages/group/screens/create_group_screen.dart';
import 'package:attendance_/pages/home/home_screen.dart';
import 'package:attendance_/pages/class_and_subject/subject_screen.dart';
import 'package:attendance_/pages/lesson_class/create_lesson_class_screen.dart';
import 'package:attendance_/pages/lessons_attendance_for_student/lessons_for_student.dart';

import 'package:attendance_/pages/otp_phone/otp_screen.dart';

import 'package:attendance_/pages/select_contacts/screens/select_contact_screen.dart';

import 'package:attendance_/pages/user_information/user_information.dart';

import '../../web/main.dart';
import '../../web/page/auth/otp_web.dart';
import '../../web/page/auth/verification_confirmation.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AttendanceScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final idLesson = arguments['idLesson'];
      final lessonName = arguments['lessonName'];
      final idClass = arguments['idClass'];
      final nameClass = arguments['nameClass'];
      final secondsAttendance = arguments['secondsAttendance'];
      return MaterialPageRoute(
        builder: (context) => AttendanceScreen(
          idLesson: idLesson,
          lessonName: lessonName,
          idClass: idClass,
          nameClass: nameClass,
          secondsAttendance: secondsAttendance,
        ),
      );
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case DetailsClassScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final idSubject = arguments['idSubject'];
      final nameSubject = arguments['nameSubject'];
      return MaterialPageRoute(
        builder: (context) =>
            DetailsClassScreen(idSubject: idSubject, nameSubject: nameSubject),
      );

    case Subject.routeName:
      return MaterialPageRoute(builder: (context) => const Subject());
    case CreateLessonScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final idSubject = arguments['idSubject'];
      final nameSubject = arguments['nameSubject'];
      return MaterialPageRoute(
        builder: (context) =>
            CreateLessonScreen(idSubject: idSubject, nameSubject: nameSubject),
      );

    case DisplayQrScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final data = arguments['data'];
      return MaterialPageRoute(
        builder: (context) => DisplayQrScreen(data: data),
      );

    case AppHomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AppHomeScreen(),
      );

    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
        builder: (context) => MobileChatScreen(
          name: name,
          uid: uid,
          isGroupChat: isGroupChat,
          profilePic: profilePic,
        ),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectContactScreen(),
      );

    case CreateGroupScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateGroupScreen(),
      );
    case MobileLayoutScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const MobileLayoutScreen(),
      );

    case LessonAttendanceForStudent.routeName:
      return MaterialPageRoute(
        builder: (context) => const LessonAttendanceForStudent(),
      );
    case UserProfile.routeName:
      final uid = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => UserProfile(uid: uid),
      );

    case EditProfile.routeName:
      final uid = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => EditProfile(uid: uid),
      );
    case LoginWeb.routeName:
      return MaterialPageRoute(builder: (context) => const LoginWeb());
    case OTPWeb.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTPWeb(verificationId: verificationId));
    case MyHomePage.routeName:
      return MaterialPageRoute(builder: (context)=>const MyHomePage());

    default:
      return MaterialPageRoute(
        builder: (context) =>
            const ErrorScreen(text: "This page does'n not exist"),
      );
  }
}
