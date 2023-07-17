// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserModel _$$_UserModelFromJson(Map<String, dynamic> json) => _$_UserModel(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePic: json['profilePic'] as String,
      phoneNumber: json['phoneNumber'] as String,
      code: json['code'] as String,
      banner: json['banner'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] as String,
      isOnline: json['isOnline'] as bool,
      groupId:
          (json['groupId'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_UserModelToJson(_$_UserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'profilePic': instance.profilePic,
      'phoneNumber': instance.phoneNumber,
      'code': instance.code,
      'banner': instance.banner,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt,
      'isOnline': instance.isOnline,
      'groupId': instance.groupId,
    };
