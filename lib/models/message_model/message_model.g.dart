// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MessageModel _$$_MessageModelFromJson(Map<String, dynamic> json) =>
    _$_MessageModel(
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      messageId: json['messageId'] as String,
      text: json['text'] as String,
      type: $enumDecode(_$MessageEnumEnumMap, json['type']),
      timeSent: DateTime.parse(json['timeSent'] as String),
      isSeen: json['isSeen'] as bool,
      repliedMessage: json['repliedMessage'] as String,
      repliedTo: json['repliedTo'] as String,
      typeReply: $enumDecode(_$MessageEnumEnumMap, json['typeReply']),
    );

Map<String, dynamic> _$$_MessageModelToJson(_$_MessageModel instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'messageId': instance.messageId,
      'text': instance.text,
      'type': _$MessageEnumEnumMap[instance.type]!,
      'timeSent': instance.timeSent.toIso8601String(),
      'isSeen': instance.isSeen,
      'repliedMessage': instance.repliedMessage,
      'repliedTo': instance.repliedTo,
      'typeReply': _$MessageEnumEnumMap[instance.typeReply]!,
    };

const _$MessageEnumEnumMap = {
  MessageEnum.text: 'text',
  MessageEnum.image: 'image',
  MessageEnum.audio: 'audio',
  MessageEnum.video: 'video',
  MessageEnum.gif: 'gif',
};
