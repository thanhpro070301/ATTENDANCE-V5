// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_for_class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AttendanceForClassModel _$$_AttendanceForClassModelFromJson(
        Map<String, dynamic> json) =>
    _$_AttendanceForClassModel(
      id: json['id'] as String,
      idStudent: json['idStudent'] as String,
      idClass: json['idClass'] as String,
      code: json['code'] as String,
      uidCreatorClass: json['uidCreatorClass'] as String,
      nameStudent: json['nameStudent'] as String,
      phoneStudent: json['phoneStudent'] as String,
      statusAttendance: json['statusAttendance'] as String,
      deviceName: json['deviceName'] as String,
      createdAt: json['createdAt'] as String,
      location: json['location'] as String,
      timeAttendance: json['timeAttendance'] as String,
    );

Map<String, dynamic> _$$_AttendanceForClassModelToJson(
        _$_AttendanceForClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idStudent': instance.idStudent,
      'idClass': instance.idClass,
      'code': instance.code,
      'uidCreatorClass': instance.uidCreatorClass,
      'nameStudent': instance.nameStudent,
      'phoneStudent': instance.phoneStudent,
      'statusAttendance': instance.statusAttendance,
      'deviceName': instance.deviceName,
      'createdAt': instance.createdAt,
      'location': instance.location,
      'timeAttendance': instance.timeAttendance,
    };
