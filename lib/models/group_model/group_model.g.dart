// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GroupModel _$$_GroupModelFromJson(Map<String, dynamic> json) =>
    _$_GroupModel(
      senderId: json['senderId'] as String,
      name: json['name'] as String,
      groupId: json['groupId'] as String,
      lastMessage: json['lastMessage'] as String,
      groupPic: json['groupPic'] as String,
      membersUid: (json['membersUid'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      timeSent: DateTime.parse(json['timeSent'] as String),
    );

Map<String, dynamic> _$$_GroupModelToJson(_$_GroupModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'name': instance.name,
      'groupId': instance.groupId,
      'lastMessage': instance.lastMessage,
      'groupPic': instance.groupPic,
      'membersUid': instance.membersUid,
      'timeSent': instance.timeSent.toIso8601String(),
    };
