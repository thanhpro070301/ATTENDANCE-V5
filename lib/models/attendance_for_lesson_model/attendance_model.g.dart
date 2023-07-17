// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AttendanceModel _$$_AttendanceModelFromJson(Map<String, dynamic> json) =>
    _$_AttendanceModel(
      id: json['id'] as String,
      idStudent: json['idStudent'] as String,
      idLesson: json['idLesson'] as String,
      idSubject: json['idSubject'] as String,
      uidCreatorLesson: json['uidCreatorLesson'] as String,
      nameStudent: json['nameStudent'] as String,
      statusAttendance: json['statusAttendance'] as String,
      deviceName: json['deviceName'] as String,
      createdAt: json['createdAt'] as String,
      location: json['location'] as String,
      timeAttendance: json['timeAttendance'] as String,
    );

Map<String, dynamic> _$$_AttendanceModelToJson(_$_AttendanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idStudent': instance.idStudent,
      'idLesson': instance.idLesson,
      'idSubject': instance.idSubject,
      'uidCreatorLesson': instance.uidCreatorLesson,
      'nameStudent': instance.nameStudent,
      'statusAttendance': instance.statusAttendance,
      'deviceName': instance.deviceName,
      'createdAt': instance.createdAt,
      'location': instance.location,
      'timeAttendance': instance.timeAttendance,
    };
