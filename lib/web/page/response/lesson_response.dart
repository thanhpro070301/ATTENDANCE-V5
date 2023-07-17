class LessonResponse {
  late final String createdAt;
  late final String startTime;
  late final String endTime;
  late final String attendanceTime;
  late final String lessonName;
  late final bool isPresent;

  LessonResponse(
      {required this.createdAt,
      required this.startTime,
      required this.endTime,
      required this.attendanceTime,
      required this.lessonName,
      required this.isPresent});
}
