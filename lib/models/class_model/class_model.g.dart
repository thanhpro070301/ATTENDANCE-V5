// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ClassModel _$$_ClassModelFromJson(Map<String, dynamic> json) =>
    _$_ClassModel(
      id: json['id'] as String,
      nameClass: json['nameClass'] as String,
      uidCreator: json['uidCreator'] as String,
      listUserPhone: (json['listUserPhone'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      present: json['present'] as int,
      endAttendance: json['endAttendance'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      absent: json['absent'] as int,
    );

Map<String, dynamic> _$$_ClassModelToJson(_$_ClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameClass': instance.nameClass,
      'uidCreator': instance.uidCreator,
      'listUserPhone': instance.listUserPhone,
      'present': instance.present,
      'endAttendance': instance.endAttendance,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'absent': instance.absent,
    };
