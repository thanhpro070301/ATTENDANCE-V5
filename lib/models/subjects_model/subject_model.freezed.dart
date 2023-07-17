// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subject_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SubjectModel _$SubjectModelFromJson(Map<String, dynamic> json) {
  return _SubjectModel.fromJson(json);
}

/// @nodoc
mixin _$SubjectModel {
  String get id => throw _privateConstructorUsedError;
  String get nameSubject => throw _privateConstructorUsedError;
  String get uid => throw _privateConstructorUsedError;
  String get nameTeacher => throw _privateConstructorUsedError;
  List<String> get lessons => throw _privateConstructorUsedError;
  List<String> get listUserPhone => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SubjectModelCopyWith<SubjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubjectModelCopyWith<$Res> {
  factory $SubjectModelCopyWith(
          SubjectModel value, $Res Function(SubjectModel) then) =
      _$SubjectModelCopyWithImpl<$Res, SubjectModel>;
  @useResult
  $Res call(
      {String id,
      String nameSubject,
      String uid,
      String nameTeacher,
      List<String> lessons,
      List<String> listUserPhone,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class _$SubjectModelCopyWithImpl<$Res, $Val extends SubjectModel>
    implements $SubjectModelCopyWith<$Res> {
  _$SubjectModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameSubject = null,
    Object? uid = null,
    Object? nameTeacher = null,
    Object? lessons = null,
    Object? listUserPhone = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameSubject: null == nameSubject
          ? _value.nameSubject
          : nameSubject // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      nameTeacher: null == nameTeacher
          ? _value.nameTeacher
          : nameTeacher // ignore: cast_nullable_to_non_nullable
              as String,
      lessons: null == lessons
          ? _value.lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      listUserPhone: null == listUserPhone
          ? _value.listUserPhone
          : listUserPhone // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SubjectModelCopyWith<$Res>
    implements $SubjectModelCopyWith<$Res> {
  factory _$$_SubjectModelCopyWith(
          _$_SubjectModel value, $Res Function(_$_SubjectModel) then) =
      __$$_SubjectModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String nameSubject,
      String uid,
      String nameTeacher,
      List<String> lessons,
      List<String> listUserPhone,
      String createdAt,
      String updatedAt});
}

/// @nodoc
class __$$_SubjectModelCopyWithImpl<$Res>
    extends _$SubjectModelCopyWithImpl<$Res, _$_SubjectModel>
    implements _$$_SubjectModelCopyWith<$Res> {
  __$$_SubjectModelCopyWithImpl(
      _$_SubjectModel _value, $Res Function(_$_SubjectModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nameSubject = null,
    Object? uid = null,
    Object? nameTeacher = null,
    Object? lessons = null,
    Object? listUserPhone = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$_SubjectModel(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nameSubject: null == nameSubject
          ? _value.nameSubject
          : nameSubject // ignore: cast_nullable_to_non_nullable
              as String,
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      nameTeacher: null == nameTeacher
          ? _value.nameTeacher
          : nameTeacher // ignore: cast_nullable_to_non_nullable
              as String,
      lessons: null == lessons
          ? _value._lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<String>,
      listUserPhone: null == listUserPhone
          ? _value._listUserPhone
          : listUserPhone // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SubjectModel implements _SubjectModel {
  _$_SubjectModel(
      {required this.id,
      required this.nameSubject,
      required this.uid,
      required this.nameTeacher,
      required final List<String> lessons,
      required final List<String> listUserPhone,
      required this.createdAt,
      required this.updatedAt})
      : _lessons = lessons,
        _listUserPhone = listUserPhone;

  factory _$_SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$$_SubjectModelFromJson(json);

  @override
  final String id;
  @override
  final String nameSubject;
  @override
  final String uid;
  @override
  final String nameTeacher;
  final List<String> _lessons;
  @override
  List<String> get lessons {
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lessons);
  }

  final List<String> _listUserPhone;
  @override
  List<String> get listUserPhone {
    if (_listUserPhone is EqualUnmodifiableListView) return _listUserPhone;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listUserPhone);
  }

  @override
  final String createdAt;
  @override
  final String updatedAt;

  @override
  String toString() {
    return 'SubjectModel(id: $id, nameSubject: $nameSubject, uid: $uid, nameTeacher: $nameTeacher, lessons: $lessons, listUserPhone: $listUserPhone, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SubjectModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameSubject, nameSubject) ||
                other.nameSubject == nameSubject) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.nameTeacher, nameTeacher) ||
                other.nameTeacher == nameTeacher) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons) &&
            const DeepCollectionEquality()
                .equals(other._listUserPhone, _listUserPhone) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      nameSubject,
      uid,
      nameTeacher,
      const DeepCollectionEquality().hash(_lessons),
      const DeepCollectionEquality().hash(_listUserPhone),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SubjectModelCopyWith<_$_SubjectModel> get copyWith =>
      __$$_SubjectModelCopyWithImpl<_$_SubjectModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SubjectModelToJson(
      this,
    );
  }
}

abstract class _SubjectModel implements SubjectModel {
  factory _SubjectModel(
      {required final String id,
      required final String nameSubject,
      required final String uid,
      required final String nameTeacher,
      required final List<String> lessons,
      required final List<String> listUserPhone,
      required final String createdAt,
      required final String updatedAt}) = _$_SubjectModel;

  factory _SubjectModel.fromJson(Map<String, dynamic> json) =
      _$_SubjectModel.fromJson;

  @override
  String get id;
  @override
  String get nameSubject;
  @override
  String get uid;
  @override
  String get nameTeacher;
  @override
  List<String> get lessons;
  @override
  List<String> get listUserPhone;
  @override
  String get createdAt;
  @override
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_SubjectModelCopyWith<_$_SubjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}
