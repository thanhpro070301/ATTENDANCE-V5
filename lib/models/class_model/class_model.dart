import 'package:freezed_annotation/freezed_annotation.dart';
part 'class_model.freezed.dart';
part 'class_model.g.dart';

@freezed
class ClassModel with _$ClassModel {
  factory ClassModel({
    required String id,
    required String nameClass,
    required String uidCreator,
    required List<String> listUserPhone,
    required int present,
    required String endAttendance,
    required String createdAt,
    required String updatedAt,
    required int absent,
  }) = _ClassModel;
  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);
}
