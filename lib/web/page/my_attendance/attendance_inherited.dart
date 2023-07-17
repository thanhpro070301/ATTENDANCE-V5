import 'package:attendance_/models/subjects_model/subject_model.dart';
import 'package:flutter/material.dart';

import '../../../models/class_model/class_model.dart';

class AttendanceInherited extends InheritedWidget {
  final List<SubjectModel> listSubject;
  final List<ClassModel> listClass;
  final DateTime dateFilter;

  const AttendanceInherited({
    Key? key,
    required this.listSubject,
    required this.dateFilter,
    required Widget child,
    required this.listClass,
  }) : super(key: key, child: child);

  static AttendanceInherited of(BuildContext context) {
    final AttendanceInherited? result =
        context.dependOnInheritedWidgetOfExactType<AttendanceInherited>();
    assert(result != null, 'No AttendanceInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AttendanceInherited oldWidget) {
    return listSubject != oldWidget.listSubject &&
        dateFilter != oldWidget.dateFilter &&
        listClass != oldWidget.listClass;
  }
}
