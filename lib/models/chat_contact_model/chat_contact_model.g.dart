// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_contact_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChatContactModel _$$_ChatContactModelFromJson(Map<String, dynamic> json) =>
    _$_ChatContactModel(
      name: json['name'] as String,
      profilePic: json['profilePic'] as String,
      contactId: json['contactId'] as String,
      timeSent: DateTime.parse(json['timeSent'] as String),
      lastMessenger: json['lastMessenger'] as String,
    );

Map<String, dynamic> _$$_ChatContactModelToJson(_$_ChatContactModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'profilePic': instance.profilePic,
      'contactId': instance.contactId,
      'timeSent': instance.timeSent.toIso8601String(),
      'lastMessenger': instance.lastMessenger,
    };
