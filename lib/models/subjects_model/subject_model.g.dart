// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SubjectModel _$$_SubjectModelFromJson(Map<String, dynamic> json) =>
    _$_SubjectModel(
      id: json['id'] as String,
      nameSubject: json['nameSubject'] as String,
      uid: json['uid'] as String,
      nameTeacher: json['nameTeacher'] as String,
      lessons:
          (json['lessons'] as List<dynamic>).map((e) => e as String).toList(),
      listUserPhone: (json['listUserPhone'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$_SubjectModelToJson(_$_SubjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameSubject': instance.nameSubject,
      'uid': instance.uid,
      'nameTeacher': instance.nameTeacher,
      'lessons': instance.lessons,
      'listUserPhone': instance.listUserPhone,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
