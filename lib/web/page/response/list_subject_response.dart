import 'lesson_response.dart';

class SubjectResponse {
  late final String subjectName;
  late final List<LessonResponse> lessonResponse;

  SubjectResponse({required this.subjectName, required this.lessonResponse});
}
