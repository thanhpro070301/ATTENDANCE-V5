import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:attendance_/common/enum/status_attendance_enum.dart';

final statusAttendanceProvider = StateProvider.autoDispose<StatusAttendance>(
    (ref) => StatusAttendance.present);

final buttonColorProvider = StateProvider.autoDispose(
  (ref) {
    return Colors.white;
  },
);

final counterProvider = StateProvider((ref) => 0);
