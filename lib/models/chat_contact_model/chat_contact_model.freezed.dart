// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_contact_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChatContactModel _$ChatContactModelFromJson(Map<String, dynamic> json) {
  return _ChatContactModel.fromJson(json);
}

/// @nodoc
mixin _$ChatContactModel {
  String get name => throw _privateConstructorUsedError;
  String get profilePic => throw _privateConstructorUsedError;
  String get contactId => throw _privateConstructorUsedError;
  DateTime get timeSent => throw _privateConstructorUsedError;
  String get lastMessenger => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatContactModelCopyWith<ChatContactModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatContactModelCopyWith<$Res> {
  factory $ChatContactModelCopyWith(
          ChatContactModel value, $Res Function(ChatContactModel) then) =
      _$ChatContactModelCopyWithImpl<$Res, ChatContactModel>;
  @useResult
  $Res call(
      {String name,
      String profilePic,
      String contactId,
      DateTime timeSent,
      String lastMessenger});
}

/// @nodoc
class _$ChatContactModelCopyWithImpl<$Res, $Val extends ChatContactModel>
    implements $ChatContactModelCopyWith<$Res> {
  _$ChatContactModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? profilePic = null,
    Object? contactId = null,
    Object? timeSent = null,
    Object? lastMessenger = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profilePic: null == profilePic
          ? _value.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
      timeSent: null == timeSent
          ? _value.timeSent
          : timeSent // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastMessenger: null == lastMessenger
          ? _value.lastMessenger
          : lastMessenger // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChatContactModelCopyWith<$Res>
    implements $ChatContactModelCopyWith<$Res> {
  factory _$$_ChatContactModelCopyWith(
          _$_ChatContactModel value, $Res Function(_$_ChatContactModel) then) =
      __$$_ChatContactModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String profilePic,
      String contactId,
      DateTime timeSent,
      String lastMessenger});
}

/// @nodoc
class __$$_ChatContactModelCopyWithImpl<$Res>
    extends _$ChatContactModelCopyWithImpl<$Res, _$_ChatContactModel>
    implements _$$_ChatContactModelCopyWith<$Res> {
  __$$_ChatContactModelCopyWithImpl(
      _$_ChatContactModel _value, $Res Function(_$_ChatContactModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? profilePic = null,
    Object? contactId = null,
    Object? timeSent = null,
    Object? lastMessenger = null,
  }) {
    return _then(_$_ChatContactModel(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      profilePic: null == profilePic
          ? _value.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
      timeSent: null == timeSent
          ? _value.timeSent
          : timeSent // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastMessenger: null == lastMessenger
          ? _value.lastMessenger
          : lastMessenger // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChatContactModel implements _ChatContactModel {
  _$_ChatContactModel(
      {required this.name,
      required this.profilePic,
      required this.contactId,
      required this.timeSent,
      required this.lastMessenger});

  factory _$_ChatContactModel.fromJson(Map<String, dynamic> json) =>
      _$$_ChatContactModelFromJson(json);

  @override
  final String name;
  @override
  final String profilePic;
  @override
  final String contactId;
  @override
  final DateTime timeSent;
  @override
  final String lastMessenger;

  @override
  String toString() {
    return 'ChatContactModel(name: $name, profilePic: $profilePic, contactId: $contactId, timeSent: $timeSent, lastMessenger: $lastMessenger)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatContactModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.timeSent, timeSent) ||
                other.timeSent == timeSent) &&
            (identical(other.lastMessenger, lastMessenger) ||
                other.lastMessenger == lastMessenger));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, profilePic, contactId, timeSent, lastMessenger);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatContactModelCopyWith<_$_ChatContactModel> get copyWith =>
      __$$_ChatContactModelCopyWithImpl<_$_ChatContactModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChatContactModelToJson(
      this,
    );
  }
}

abstract class _ChatContactModel implements ChatContactModel {
  factory _ChatContactModel(
      {required final String name,
      required final String profilePic,
      required final String contactId,
      required final DateTime timeSent,
      required final String lastMessenger}) = _$_ChatContactModel;

  factory _ChatContactModel.fromJson(Map<String, dynamic> json) =
      _$_ChatContactModel.fromJson;

  @override
  String get name;
  @override
  String get profilePic;
  @override
  String get contactId;
  @override
  DateTime get timeSent;
  @override
  String get lastMessenger;
  @override
  @JsonKey(ignore: true)
  _$$_ChatContactModelCopyWith<_$_ChatContactModel> get copyWith =>
      throw _privateConstructorUsedError;
}
