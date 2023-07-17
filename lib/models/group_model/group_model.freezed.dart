// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) {
  return _GroupModel.fromJson(json);
}

/// @nodoc
mixin _$GroupModel {
  String get senderId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  String get groupPic => throw _privateConstructorUsedError;
  List<String> get membersUid => throw _privateConstructorUsedError;
  DateTime get timeSent => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GroupModelCopyWith<GroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupModelCopyWith<$Res> {
  factory $GroupModelCopyWith(
          GroupModel value, $Res Function(GroupModel) then) =
      _$GroupModelCopyWithImpl<$Res, GroupModel>;
  @useResult
  $Res call(
      {String senderId,
      String name,
      String groupId,
      String lastMessage,
      String groupPic,
      List<String> membersUid,
      DateTime timeSent});
}

/// @nodoc
class _$GroupModelCopyWithImpl<$Res, $Val extends GroupModel>
    implements $GroupModelCopyWith<$Res> {
  _$GroupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = null,
    Object? name = null,
    Object? groupId = null,
    Object? lastMessage = null,
    Object? groupPic = null,
    Object? membersUid = null,
    Object? timeSent = null,
  }) {
    return _then(_value.copyWith(
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      groupPic: null == groupPic
          ? _value.groupPic
          : groupPic // ignore: cast_nullable_to_non_nullable
              as String,
      membersUid: null == membersUid
          ? _value.membersUid
          : membersUid // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timeSent: null == timeSent
          ? _value.timeSent
          : timeSent // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GroupModelCopyWith<$Res>
    implements $GroupModelCopyWith<$Res> {
  factory _$$_GroupModelCopyWith(
          _$_GroupModel value, $Res Function(_$_GroupModel) then) =
      __$$_GroupModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String senderId,
      String name,
      String groupId,
      String lastMessage,
      String groupPic,
      List<String> membersUid,
      DateTime timeSent});
}

/// @nodoc
class __$$_GroupModelCopyWithImpl<$Res>
    extends _$GroupModelCopyWithImpl<$Res, _$_GroupModel>
    implements _$$_GroupModelCopyWith<$Res> {
  __$$_GroupModelCopyWithImpl(
      _$_GroupModel _value, $Res Function(_$_GroupModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? senderId = null,
    Object? name = null,
    Object? groupId = null,
    Object? lastMessage = null,
    Object? groupPic = null,
    Object? membersUid = null,
    Object? timeSent = null,
  }) {
    return _then(_$_GroupModel(
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      groupPic: null == groupPic
          ? _value.groupPic
          : groupPic // ignore: cast_nullable_to_non_nullable
              as String,
      membersUid: null == membersUid
          ? _value._membersUid
          : membersUid // ignore: cast_nullable_to_non_nullable
              as List<String>,
      timeSent: null == timeSent
          ? _value.timeSent
          : timeSent // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GroupModel implements _GroupModel {
  _$_GroupModel(
      {required this.senderId,
      required this.name,
      required this.groupId,
      required this.lastMessage,
      required this.groupPic,
      required final List<String> membersUid,
      required this.timeSent})
      : _membersUid = membersUid;

  factory _$_GroupModel.fromJson(Map<String, dynamic> json) =>
      _$$_GroupModelFromJson(json);

  @override
  final String senderId;
  @override
  final String name;
  @override
  final String groupId;
  @override
  final String lastMessage;
  @override
  final String groupPic;
  final List<String> _membersUid;
  @override
  List<String> get membersUid {
    if (_membersUid is EqualUnmodifiableListView) return _membersUid;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_membersUid);
  }

  @override
  final DateTime timeSent;

  @override
  String toString() {
    return 'GroupModel(senderId: $senderId, name: $name, groupId: $groupId, lastMessage: $lastMessage, groupPic: $groupPic, membersUid: $membersUid, timeSent: $timeSent)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GroupModel &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.groupPic, groupPic) ||
                other.groupPic == groupPic) &&
            const DeepCollectionEquality()
                .equals(other._membersUid, _membersUid) &&
            (identical(other.timeSent, timeSent) ||
                other.timeSent == timeSent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      senderId,
      name,
      groupId,
      lastMessage,
      groupPic,
      const DeepCollectionEquality().hash(_membersUid),
      timeSent);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GroupModelCopyWith<_$_GroupModel> get copyWith =>
      __$$_GroupModelCopyWithImpl<_$_GroupModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GroupModelToJson(
      this,
    );
  }
}

abstract class _GroupModel implements GroupModel {
  factory _GroupModel(
      {required final String senderId,
      required final String name,
      required final String groupId,
      required final String lastMessage,
      required final String groupPic,
      required final List<String> membersUid,
      required final DateTime timeSent}) = _$_GroupModel;

  factory _GroupModel.fromJson(Map<String, dynamic> json) =
      _$_GroupModel.fromJson;

  @override
  String get senderId;
  @override
  String get name;
  @override
  String get groupId;
  @override
  String get lastMessage;
  @override
  String get groupPic;
  @override
  List<String> get membersUid;
  @override
  DateTime get timeSent;
  @override
  @JsonKey(ignore: true)
  _$$_GroupModelCopyWith<_$_GroupModel> get copyWith =>
      throw _privateConstructorUsedError;
}
