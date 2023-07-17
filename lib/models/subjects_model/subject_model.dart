import 'package:freezed_annotation/freezed_annotation.dart';
part 'subject_model.freezed.dart';
part 'subject_model.g.dart';

@freezed
class SubjectModel with _$SubjectModel {
  factory SubjectModel({
    required String id,
    required String nameSubject,
    required final String uid,
    required final String nameTeacher,
    required List<String> lessons,
    required List<String> listUserPhone,
    required String createdAt,
    required String updatedAt,
  }) = _SubjectModel;
  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);
}
