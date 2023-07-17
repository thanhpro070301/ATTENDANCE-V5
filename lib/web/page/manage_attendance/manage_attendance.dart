import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/attendance/controller/attendance_controller.dart';
import 'package:attendance_/web/page/auth/controller/auth_controller.dart';
import 'package:attendance_/web/page/auth/provider/auth_provider.dart';
import 'package:attendance_/web/page/response/attendance_response.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

import '../../../pages/class_and_subject/class/controller/class_controller.dart';
import '../../../pages/class_and_subject/subject/controller/subject_controller.dart';
import '../../../pages/lesson_class/controller/lesson_controller.dart';
import '../response/list_student_subject_response.dart';
import '../response/student_response.dart';
import '../widget/chart/bar_chart.dart';
import '../widget/chart/line_chart.dart';

class ManageAttendanceScreen extends ConsumerWidget {
  const ManageAttendanceScreen(
      {Key? key,
      required this.selectIdDropdown,
      required this.selectValueDropdown,
      required this.selectTitleDropdown,
      required this.selectDate})
      : super(key: key);
  final String selectValueDropdown;
  final String selectIdDropdown;
  final String selectTitleDropdown;
  final DateTime selectDate;

  @override
  Widget build(BuildContext context, ref) {
    final user = ref.watch(userProvider)!;
    TextStyle styleTitle = const TextStyle(fontSize: 18);

    List<AttendanceResponse> listAttendanceResponse = [];
    List<StudentsSubjectResponse> listSubjectResponse = [];
    List<StudentsSubjectResponse> listSubjectPresentResponse = [];
    List<StudentsSubjectResponse> listSubjectAbsentResponse = [];
    List<Map<String, double>> absentData = [];
    List<Map<String, double>> presentData = [];

    final List<FlSpot> defaultValues = [
      const FlSpot(0, 0),
      const FlSpot(1, 0),
      const FlSpot(2, 0),
      const FlSpot(3, 0),
      const FlSpot(4, 0),
      const FlSpot(5, 0),
      const FlSpot(6, 0),
      const FlSpot(7, 0),
      const FlSpot(8, 0),
      const FlSpot(9, 0),
      const FlSpot(10, 0),
      const FlSpot(11, 0),
    ];
    List<FlSpot> absentValues = defaultValues;
    List<FlSpot> presentValues = defaultValues;
    int totalStudent = 0;
    int totalStudentPresent = 0;
    int totalStudentAbsent = 0;
    DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

    if (selectTitleDropdown == "Chủ đề") {
      listSubjectPresentResponse = [];
      listSubjectAbsentResponse = [];
      listAttendanceResponse = [];
      listSubjectResponse = [];
      totalStudent = 0;
      totalStudentPresent = 0;
      totalStudentAbsent = 0;
      absentValues = [
        const FlSpot(0, 0),
        const FlSpot(1, 0),
        const FlSpot(2, 0),
        const FlSpot(3, 0),
        const FlSpot(4, 0),
        const FlSpot(5, 0),
        const FlSpot(6, 0),
        const FlSpot(7, 0),
        const FlSpot(8, 0),
        const FlSpot(9, 0),
        const FlSpot(10, 0),
        const FlSpot(11, 0),
      ];
      presentValues = [
        const FlSpot(0, 0),
        const FlSpot(1, 0),
        const FlSpot(2, 0),
        const FlSpot(3, 0),
        const FlSpot(4, 0),
        const FlSpot(5, 0),
        const FlSpot(6, 0),
        const FlSpot(7, 0),
        const FlSpot(8, 0),
        const FlSpot(9, 0),
        const FlSpot(10, 0),
        const FlSpot(11, 0),
      ];
      absentData = [];
      presentData = [];

      var dateOfWeek =
          getDate(selectDate.subtract(Duration(days: selectDate.weekday - 1)));
      for (int i = 0; i < 7; i++) {
        String dateWeek = DateFormat("dd-MM-yyyy").format(dateOfWeek);
        var result = ref.watch(getSubjectProvider(user.uid)).value;
        if (result != null) {
          if (selectIdDropdown != "0") {
            result = result.filter((t) => t.id == selectIdDropdown).toList();
          }
          result.forEach((element) {
            if (element.createdAt == dateWeek) {
              presentData.add({'$i': 100});
            }
          });
        }

        dateOfWeek =
            DateTime(dateOfWeek.year, dateOfWeek.month, dateOfWeek.day + 1);
      }

      var subjects = ref.watch(getSubjectProvider(user.uid)).value;

      if (subjects != null) {
        for (var element in subjects) {
          listAttendanceResponse = [];
          var attendances =
              ref.watch(getAllAttendanceBySubjectId(element.id)).value;
          if (attendances != null) {
            for (var element in attendances) {
              var student = ref.watch(getUserDataById(element.idStudent)).value;
              if (student != null) {
                totalStudent++;
                totalStudentPresent++;
                if (element.createdAt.split('-').last ==
                    DateFormat("dd-MM-yyyy")
                        .format(selectDate)
                        .split('-')
                        .last) {
                  int month =
                      DateFormat("dd-MM-yyyy").parse(element.createdAt).month -
                          1;

                  double y = presentValues[month].y;
                  presentValues[month] = FlSpot(month.toDouble(), y + 1);
                }

                listAttendanceResponse.add(AttendanceResponse(
                  avatar: student.profilePic,
                  name: student.name,
                  phone: student.phoneNumber,
                  attendanceTime: element.timeAttendance,
                  statusAttendance: (element.statusAttendance == "present"),
                  createdAt: element.createdAt,
                  percent: 100,
                  lesson: (ref
                              .watch(getLessonByIdProvider(element.idLesson))
                              .value ==
                          null)
                      ? ''
                      : ref
                          .watch(getLessonByIdProvider(element.idLesson))
                          .value!
                          .lessonName,
                ));
              }
            }
            listSubjectResponse.add(StudentsSubjectResponse(
                subjectName: element.nameSubject,
                attendanceResponse: listAttendanceResponse));
            listSubjectPresentResponse.add(StudentsSubjectResponse(
                subjectName: element.nameSubject,
                attendanceResponse: listAttendanceResponse
                    .filter((t) => t.statusAttendance == true)
                    .toList()));
            listSubjectAbsentResponse.add(StudentsSubjectResponse(
                subjectName: element.nameSubject,
                attendanceResponse: listAttendanceResponse
                    .filter((t) => t.statusAttendance != true)
                    .toList()));
          }
        }
      }
    } else {
      listSubjectPresentResponse = [];
      listSubjectAbsentResponse = [];
      listAttendanceResponse = [];
      listSubjectResponse = [];
      totalStudent = 0;
      totalStudentPresent = 0;
      totalStudentAbsent = 0;
      absentValues = [
        const FlSpot(0, 0),
        const FlSpot(1, 0),
        const FlSpot(2, 0),
        const FlSpot(3, 0),
        const FlSpot(4, 0),
        const FlSpot(5, 0),
        const FlSpot(6, 0),
        const FlSpot(7, 0),
        const FlSpot(8, 0),
        const FlSpot(9, 0),
        const FlSpot(10, 0),
        const FlSpot(11, 0),
      ];
      presentValues = [
        const FlSpot(0, 0),
        const FlSpot(1, 0),
        const FlSpot(2, 0),
        const FlSpot(3, 0),
        const FlSpot(4, 0),
        const FlSpot(5, 0),
        const FlSpot(6, 0),
        const FlSpot(7, 0),
        const FlSpot(8, 0),
        const FlSpot(9, 0),
        const FlSpot(10, 0),
        const FlSpot(11, 0),
      ];
      absentData = [];
      presentData = [];

      var getClass = ref.watch(getClassProvider(user.uid)).value;
      totalStudent = 0;
      if (getClass != null) {
        for (var element in getClass) {
          listAttendanceResponse = [];
          var attend =
              ref.watch(getAttendanceByClassProvider(element.id)).value;
          if (attend != null) {
            for (var element in attend) {
              var student = ref.watch(getUserDataById(element.idStudent)).value;
              if (student != null) {
                totalStudent++;

                if (element.createdAt.split('-').last ==
                    DateFormat("dd-MM-yyyy")
                        .format(selectDate)
                        .split('-')
                        .last) {
                  int month =
                      DateFormat("dd-MM-yyyy").parse(element.createdAt).month -
                          1;

                  if (element.statusAttendance == "present") {
                    double y = presentValues[month].y;
                    presentValues[month] = FlSpot(month.toDouble(), y + 1);
                    totalStudentPresent++;
                  } else {
                    double y = absentValues[month].y;
                    absentValues[month] = FlSpot(month.toDouble(), y + 1);
                    totalStudentAbsent++;
                  }
                }

                listAttendanceResponse.add(AttendanceResponse(
                  avatar: student.profilePic,
                  name: student.name,
                  phone: student.phoneNumber,
                  attendanceTime: element.timeAttendance,
                  statusAttendance: (element.statusAttendance == "present"),
                  createdAt: element.createdAt,
                  percent: 100,
                  lesson: '',
                ));
              }
            }

            listSubjectResponse.add(StudentsSubjectResponse(
                subjectName: element.nameClass,
                attendanceResponse: listAttendanceResponse));
            listSubjectPresentResponse.add(StudentsSubjectResponse(
                subjectName: element.nameClass,
                attendanceResponse: listAttendanceResponse
                    .filter((t) => t.statusAttendance == true)
                    .toList()));
            listSubjectAbsentResponse.add(StudentsSubjectResponse(
                subjectName: element.nameClass,
                attendanceResponse: listAttendanceResponse
                    .filter((t) => t.statusAttendance != true)
                    .toList()));
          }
        }
      }
    }

    if (selectIdDropdown != "0") {
      listSubjectResponse = listSubjectResponse
          .filter((t) => t.subjectName == selectValueDropdown)
          .toList();
      listSubjectAbsentResponse = listSubjectAbsentResponse
          .filter((t) => t.subjectName == selectValueDropdown)
          .toList();
      listSubjectPresentResponse = listSubjectPresentResponse
          .filter((t) => t.subjectName == selectValueDropdown)
          .toList();
      totalStudent = listSubjectResponse
          .filter((t) => t.subjectName == selectValueDropdown)
          .first
          .attendanceResponse
          .length;
      totalStudentAbsent = listSubjectAbsentResponse
          .filter((t) => t.subjectName == selectValueDropdown)
          .first
          .attendanceResponse
          .length;
      totalStudentPresent = listSubjectPresentResponse
          .filter((t) => t.subjectName == selectValueDropdown)
          .first
          .attendanceResponse
          .length;
    }

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        _studentStatusLayout(
            context, Icons.person_outline, 'STUDENTS', '$totalStudent',
            onTap: () => _viewDetails(context, styleTitle,
                listStudentSubjectResponse: (selectIdDropdown == "0")
                    ? listSubjectResponse
                    : listSubjectResponse)),
        _studentStatusLayout(
            context, Icons.person_outline, 'PRESENT', '$totalStudentPresent',
            backroundColor: Colors.green,
            onTap: () => _viewDetails(context, styleTitle,
                listStudentSubjectResponse: listSubjectPresentResponse)),
        _studentStatusLayout(
            context, Icons.person_outline, 'ABSENT', '$totalStudentAbsent',
            backroundColor: Colors.red,
            onTap: () => _viewDetails(context, styleTitle,
                listStudentSubjectResponse: listSubjectAbsentResponse)),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.4,
          child: LineChartSample7(
            listLineBarData: [
              LineChartBarData(
                spots: presentValues,
                isCurved: true,
                barWidth: 2,
                color: Colors.green,
                dotData: const FlDotData(
                  show: false,
                ),
              ),
              LineChartBarData(
                spots: absentValues,
                isCurved: false,
                barWidth: 2,
                color: Colors.red,
                dotData: const FlDotData(
                  show: false,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.4,
          child: BarChartSample2(
            absentData: (selectTitleDropdown == "Nhóm")
                ? [
                    {'0': 0},
                    {'1': 50},
                    {'2': 0},
                    {'3': 0},
                    {'4': 30},
                    {'5': 0},
                    {'6': 50},
                  ]
                : [],
            presentData: (selectTitleDropdown == "Nhóm")
                ? [
                    {'0': 100},
                    {'1': 50},
                    {'2': 100},
                    {'3': 100},
                    {'4': 70},
                    {'5': 100},
                    {'6': 50}
                  ]
                : [
                    {'0': 100},
                    {'1': 0},
                    {'2': 100},
                    {'3': 0},
                    {'4': 0},
                    {'5': 0},
                    {'6': 100},
                  ],
          ),
        ),
        // _showListStudent(context, listStudent);
      ],
    );
  }

  _viewDetails(context, styleTitle,
          {List<AttendanceResponse>? listAttendanceResponse,
          List<StudentsSubjectResponse>? listStudentSubjectResponse}) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: Row(
              children: [
                Expanded(
                    child: Text(
                  'STUDENTS of ${selectTitleDropdown.toUpperCase()} ${selectValueDropdown.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Status",
                        style: styleTitle,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Text("STUDENT", style: styleTitle),
                    ],
                  ),
                  const Text("Attendance Time",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: (listStudentSubjectResponse == null)
                      ? 0
                      : listStudentSubjectResponse.length,
                  itemBuilder: (context, index) {
                    var response = listStudentSubjectResponse![index];
                    return Column(
                      children: [
                        Text(response.subjectName),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: response.attendanceResponse.length,
                            itemBuilder: (context, index) {
                              return _showStudentLayout(
                                  response.attendanceResponse[index]);
                            })
                      ],
                    );
                  }),
            ),
          );
        },
      );

  _studentStatusLayout(context, icon, String status, String number,
      {Color backroundColor = Colors.white, required onTap}) {
    return Container(
        width: MediaQuery.of(context).size.width / 5,
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
            color: backroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ]),
        child: Tooltip(
          message: 'view details',
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(242, 243, 247, 1),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon),
            ),
            onTap: onTap,
            title: Text(
              number,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              status,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ));
  }

  _showListStudent(context, List<StudentResponse> listStudent) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(2, 4), // changes position of shadow
              ),
            ]),
        child: ListView.builder(
            itemCount: listStudent.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    const Text(
                      "Top 6 Attendant",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    _studentLayout(
                        listStudent.elementAt(index).avatar,
                        listStudent.elementAt(index).fullName,
                        listStudent.elementAt(index).percentPresent)
                  ],
                );
              } else {
                return _studentLayout(
                    listStudent.elementAt(index).avatar,
                    listStudent.elementAt(index).fullName,
                    listStudent.elementAt(index).percentPresent);
              }
            }),
      );

  _studentLayout(String avatar, String fullName, String percentPresent) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(avatar[0].toUpperCase()),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(fullName),
          Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.8),
                borderRadius: BorderRadius.circular(50)),
            child: Text(percentPresent),
          )
        ],
      ),
    );
  }

  _viewDetailsClass(context, styleTitle, {required child}) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: Row(
              children: [
                Expanded(
                    child: Text(
                  (selectIdDropdown == "0")
                      ? 'ALL STUDENT'
                      : 'ALL STUDENT of CLASS ${selectValueDropdown.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Status",
                        style: styleTitle,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Text("Student ", style: styleTitle),
                      const Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Phone number",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic),
                          ))
                    ],
                  ),
                  const Text("Attendance Time",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            content: SizedBox(
                width: MediaQuery.of(context).size.width / 2, child: child),
          );
        },
      );

  _showStudentLayout(AttendanceResponse response) => ListTile(
        leading: (response.statusAttendance)
            ? const Icon(
                Icons.verified,
                color: Colors.green,
              )
            : const Icon(
                Icons.close,
                color: Colors.red,
              ),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(response.phone)
              ],
            ),
            const SizedBox(
              width: 150,
            ),
            Text(
              response.lesson,
              textAlign: TextAlign.center,
            ),
          ],
        ),

        // subtitle: Text(response.createdAt),
        trailing: Text(response.attendanceTime),
      );
}
