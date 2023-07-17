import 'package:freezed_annotation/freezed_annotation.dart';
part 'lessons_model.freezed.dart';
part 'lessons_model.g.dart';

@freezed
class LessonsModel with _$LessonsModel {
  factory LessonsModel({
    required String id,
    required String idSubject,
    required String lessonName,
    required String roomName,
    required String location,
    required String subjectName,
    required String endAttendance,
    required String createdAt,
    required int absent,
    required int present,
  }) = _LessonsModel;
  factory LessonsModel.fromJson(Map<String, dynamic> json) =>
      _$LessonsModelFromJson(json);
}
