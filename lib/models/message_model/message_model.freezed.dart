// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get senderId => throw _privateConstructorUsedError;
  String get receiverId => throw _privateConstructorUsedError;
  String get messageId => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  MessageEnum get type => throw _privateConstructorUsedError;
  DateTime get timeSent => throw _privateConstructorUsedError;
  bool get isSeen => throw _privateConstructorUsedError;
  String get repliedMessage => throw _privateConstructorUsedError;
  String get repliedTo => throw _privateConstructorUsedError;
  MessageEnum get typeReply => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String senderId,
      String receiverId,
      String messageId,
      String text,
      MessageEnum type,
      DateTime timeSent,
      bool isSeen,
      String repliedMessage,
      String repliedTo,
      MessageEnum typeReply});
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = null,
    Object? receiverId = null,
    Object? messageId = null,
    Object? text = null,
    Object? type = null,
    Object? timeSent = null,
    Object? isSeen = null,
    Object? repliedMessage = null,
    Object? repliedTo = null,
    Object? typeReply = null,
  }) {
    return _then(_value.copyWith(
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
      timeSent: null == timeSent
          ? _value.timeSent
          : timeSent // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as bool,
      repliedMessage: null == repliedMessage
          ? _value.repliedMessage
          : repliedMessage // ignore: cast_nullable_to_non_nullable
              as String,
      repliedTo: null == repliedTo
          ? _value.repliedTo
          : repliedTo // ignore: cast_nullable_to_non_nullable
              as String,
      typeReply: null == typeReply
          ? _value.typeReply
          : typeReply // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MessageModelCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$_MessageModelCopyWith(
          _$_MessageModel value, $Res Function(_$_MessageModel) then) =
      __$$_MessageModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String senderId,
      String receiverId,
      String messageId,
      String text,
      MessageEnum type,
      DateTime timeSent,
      bool isSeen,
      String repliedMessage,
      String repliedTo,
      MessageEnum typeReply});
}

/// @nodoc
class __$$_MessageModelCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$_MessageModel>
    implements _$$_MessageModelCopyWith<$Res> {
  __$$_MessageModelCopyWithImpl(
      _$_MessageModel _value, $Res Function(_$_MessageModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = null,
    Object? receiverId = null,
    Object? messageId = null,
    Object? text = null,
    Object? type = null,
    Object? timeSent = null,
    Object? isSeen = null,
    Object? repliedMessage = null,
    Object? repliedTo = null,
    Object? typeReply = null,
  }) {
    return _then(_$_MessageModel(
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      messageId: null == messageId
          ? _value.messageId
          : messageId // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
      timeSent: null == timeSent
          ? _value.timeSent
          : timeSent // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isSeen: null == isSeen
          ? _value.isSeen
          : isSeen // ignore: cast_nullable_to_non_nullable
              as bool,
      repliedMessage: null == repliedMessage
          ? _value.repliedMessage
          : repliedMessage // ignore: cast_nullable_to_non_nullable
              as String,
      repliedTo: null == repliedTo
          ? _value.repliedTo
          : repliedTo // ignore: cast_nullable_to_non_nullable
              as String,
      typeReply: null == typeReply
          ? _value.typeReply
          : typeReply // ignore: cast_nullable_to_non_nullable
              as MessageEnum,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MessageModel implements _MessageModel {
  _$_MessageModel(
      {required this.senderId,
      required this.receiverId,
      required this.messageId,
      required this.text,
      required this.type,
      required this.timeSent,
      required this.isSeen,
      required this.repliedMessage,
      required this.repliedTo,
      required this.typeReply});

  factory _$_MessageModel.fromJson(Map<String, dynamic> json) =>
      _$$_MessageModelFromJson(json);

  @override
  final String senderId;
  @override
  final String receiverId;
  @override
  final String messageId;
  @override
  final String text;
  @override
  final MessageEnum type;
  @override
  final DateTime timeSent;
  @override
  final bool isSeen;
  @override
  final String repliedMessage;
  @override
  final String repliedTo;
  @override
  final MessageEnum typeReply;

  @override
  String toString() {
    return 'MessageModel(senderId: $senderId, receiverId: $receiverId, messageId: $messageId, text: $text, type: $type, timeSent: $timeSent, isSeen: $isSeen, repliedMessage: $repliedMessage, repliedTo: $repliedTo, typeReply: $typeReply)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MessageModel &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timeSent, timeSent) ||
                other.timeSent == timeSent) &&
            (identical(other.isSeen, isSeen) || other.isSeen == isSeen) &&
            (identical(other.repliedMessage, repliedMessage) ||
                other.repliedMessage == repliedMessage) &&
            (identical(other.repliedTo, repliedTo) ||
                other.repliedTo == repliedTo) &&
            (identical(other.typeReply, typeReply) ||
                other.typeReply == typeReply));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, senderId, receiverId, messageId,
      text, type, timeSent, isSeen, repliedMessage, repliedTo, typeReply);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessageModelCopyWith<_$_MessageModel> get copyWith =>
      __$$_MessageModelCopyWithImpl<_$_MessageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MessageModelToJson(
      this,
    );
  }
}

abstract class _MessageModel implements MessageModel {
  factory _MessageModel(
      {required final String senderId,
      required final String receiverId,
      required final String messageId,
      required final String text,
      required final MessageEnum type,
      required final DateTime timeSent,
      required final bool isSeen,
      required final String repliedMessage,
      required final String repliedTo,
      required final MessageEnum typeReply}) = _$_MessageModel;

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$_MessageModel.fromJson;

  @override
  String get senderId;
  @override
  String get receiverId;
  @override
  String get messageId;
  @override
  String get text;
  @override
  MessageEnum get type;
  @override
  DateTime get timeSent;
  @override
  bool get isSeen;
  @override
  String get repliedMessage;
  @override
  String get repliedTo;
  @override
  MessageEnum get typeReply;
  @override
  @JsonKey(ignore: true)
  _$$_MessageModelCopyWith<_$_MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}
