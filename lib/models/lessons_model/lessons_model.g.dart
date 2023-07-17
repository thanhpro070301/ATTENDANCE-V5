// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lessons_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LessonsModel _$$_LessonsModelFromJson(Map<String, dynamic> json) =>
    _$_LessonsModel(
      id: json['id'] as String,
      idSubject: json['idSubject'] as String,
      lessonName: json['lessonName'] as String,
      roomName: json['roomName'] as String,
      location: json['location'] as String,
      subjectName: json['subjectName'] as String,
      endAttendance: json['endAttendance'] as String,
      createdAt: json['createdAt'] as String,
      absent: json['absent'] as int,
      present: json['present'] as int,
    );

Map<String, dynamic> _$$_LessonsModelToJson(_$_LessonsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idSubject': instance.idSubject,
      'lessonName': instance.lessonName,
      'roomName': instance.roomName,
      'location': instance.location,
      'subjectName': instance.subjectName,
      'endAttendance': instance.endAttendance,
      'createdAt': instance.createdAt,
      'absent': instance.absent,
      'present': instance.present,
    };
