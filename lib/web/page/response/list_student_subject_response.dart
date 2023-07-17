import 'package:attendance_/web/page/response/attendance_response.dart';

class StudentsSubjectResponse {
  late final String subjectName;
  late final List<AttendanceResponse> attendanceResponse;

  StudentsSubjectResponse({required this.subjectName, required this.attendanceResponse});
}
