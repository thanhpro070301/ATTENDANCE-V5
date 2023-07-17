import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_for_class_model.freezed.dart';
part 'attendance_for_class_model.g.dart';

@freezed
class AttendanceForClassModel with _$AttendanceForClassModel {
  factory AttendanceForClassModel({
    required String id,
    required String idStudent,
    required String idClass,
    required String code,
    required String uidCreatorClass,
    required String nameStudent,
    required String phoneStudent,
    required String statusAttendance,
    required String deviceName,
    required String createdAt,
    required String location,
    required String timeAttendance,
  }) = _AttendanceForClassModel;
  factory AttendanceForClassModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceForClassModelFromJson(json);
}
