class AttendanceResponse{
  late final String name;
  late final String phone;
  late final String avatar;
  late final String lesson;
  late final String attendanceTime;
  late final bool statusAttendance;
  late final double percent;
  late final String createdAt;

  AttendanceResponse({required this.lesson, required this.percent,required this.createdAt,required this.avatar,required this.name, required this.phone, required this.attendanceTime,required this.statusAttendance,});
}
