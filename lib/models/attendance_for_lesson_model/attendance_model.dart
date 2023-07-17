import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_model.freezed.dart';
part 'attendance_model.g.dart';

@freezed
class AttendanceModel with _$AttendanceModel {
  factory AttendanceModel({
    required String id,
    required String idStudent,
    required String idLesson,
    required String idSubject,
    required String uidCreatorLesson,
    required String nameStudent,
    required String statusAttendance,
    required String deviceName,
    required String createdAt,
    required String location,
    required String timeAttendance,
  }) = _AttendanceModel;
  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceModelFromJson(json);
}
