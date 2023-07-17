import 'package:attendance_/models/attendance_for_class/attendance_for_class_model.dart';
import 'package:attendance_/models/subjects_model/subject_model.dart';
import 'package:attendance_/pages/class_and_subject/subject/controller/subject_controller.dart';
import 'package:attendance_/web/page/my_attendance/attendance_inherited.dart';
import 'package:attendance_/web/page/response/lesson_response.dart';
import 'package:attendance_/web/page/response/list_subject_response.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/error_text.dart';
import '../../../common/widgets/loading_page.dart';
import '../../../pages/attendance/controller/attendance_controller.dart';
import '../../../pages/class_and_subject/class/controller/class_controller.dart';
import '../../../pages/lesson_class/controller/lesson_controller.dart';
import '../auth/provider/auth_provider.dart';
import '../widget/chart/bar_chart.dart';
import '../widget/chart/line_chart.dart';

class MyAttendanceScreen extends ConsumerWidget {
  const MyAttendanceScreen({
    Key? key,
    required this.selectValueDropdown,
    required this.selectIdDropdown,
    required this.selectTitleDropdown,
  }) : super(key: key);
  final String selectValueDropdown;
  final String selectIdDropdown;
  final String selectTitleDropdown;

  @override
  Widget build(BuildContext context, ref) {
    TextStyle styleTitle = const TextStyle(fontSize: 18);

    final attendanceInherited =
        context.dependOnInheritedWidgetOfExactType<AttendanceInherited>();
    final user = ref.watch(userProvider)!;

    int totalAllLesson = 0;

    List<LessonResponse>? listLessonResponse;
    List<Map<String, double>> absentData = [];
    List<Map<String, double>> presentData = [];
    List<String> listResultNamePieChartPresent = [];
    List<String> listResultNamePieChartAbsent = [];

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

    DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

    List<AttendanceForClassModel> response = [];

    if (selectTitleDropdown == "Chủ đề") {
      listLessonResponse = [];
      listResultNamePieChartPresent = [];
      totalAllLesson = 0;
      presentData = [];
      absentData = [];
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
      listResultNamePieChartAbsent = [];
      listResultNamePieChartPresent = [];
      var attendances = (selectIdDropdown == "0")
          ? ref.watch(getAllAttendanceByStudentId(user.uid)).value
          : ref
              .watch(findAllAttendanceBySubjectIdAndStudentIdProvider(
                  AttendanceClassQuery(user.uid, selectIdDropdown)))
              .value;
      if (attendances != null) {
        for (var element in attendances) {
          if (element.createdAt.split('-').last ==
              DateFormat("dd-MM-yyyy")
                  .format(attendanceInherited!.dateFilter)
                  .split('-')
                  .last) {
            int month =
                DateFormat("dd-MM-yyyy").parse(element.createdAt).month - 1;
            double y = presentValues[month].y;
            presentValues[month] = FlSpot(month.toDouble(), y + 1);

            totalAllLesson++;

            var lesson =
                ref.watch(getLessonByIdProvider(element.idLesson)).value;
            if (lesson != null) {
              listLessonResponse.add(LessonResponse(
                  createdAt: lesson.createdAt,
                  startTime: '',
                  endTime: '',
                  attendanceTime: element.timeAttendance,
                  lessonName: "${lesson.subjectName} -> ${lesson.lessonName}",
                  isPresent: true));
            }
          }
        }
      }

      //get all data chart
      for (var element in attendanceInherited!.listSubject) {
        if (!listResultNamePieChartPresent.contains(element.nameSubject)) {
          listResultNamePieChartPresent.add(element.nameSubject);
        }
        var dateOfWeek = getDate(attendanceInherited.dateFilter.subtract(
            Duration(days: attendanceInherited.dateFilter.weekday - 1)));
        for (int i = 0; i < 7; i++) {
          var result = ref
              .watch(findAllAttendanceBySubjectIdAndStudentIdAndDate(
                  AttendanceByDateAndObjectIdQuery(user.uid, element.id,
                      DateFormat("dd-MM-yyyy").format(dateOfWeek))))
              .value;
          if (result != null) {
            presentData.add({'$i': 100});
          }
          dateOfWeek =
              DateTime(dateOfWeek.year, dateOfWeek.month, dateOfWeek.day + 1);
        }
      }
    } else {
      listLessonResponse = [];
      listResultNamePieChartPresent = [];
      totalAllLesson = 0;
      presentData = [];
      absentData = [];
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

      var atd =
          ref.watch(getAttendanceClassByStudentIdProvider(user.uid)).value;
      if (atd != null) {
        if (selectIdDropdown == "0") {
          response = atd;
        } else {
          var at = ref
              .watch(getAttendanceClassByStudentIdAndClassId(
                  AttendanceClassQuery(user.uid, selectIdDropdown)))
              .value;
          if (at != null) {
            response = at;
          }
        }
        totalAllLesson = response.length;
        for (var element in response) {
          if (element.createdAt.split('-').last ==
              DateFormat("dd-MM-yyyy")
                  .format(attendanceInherited!.dateFilter)
                  .split('-')
                  .last) {
            int month =
                DateFormat("dd-MM-yyyy").parse(element.createdAt).month - 1;
            bool isPresent = false;
            if (element.statusAttendance == "present") {
              double y = presentValues[month].y;
              presentValues[month] = FlSpot(month.toDouble(), y + 1);
              isPresent = true;
            } else {
              double y = absentValues[month].y;
              absentValues[month] = FlSpot(month.toDouble(), y + 1);
              isPresent = false;
            }
            var cl = ref.watch(getClassByIdProvider(element.idClass)).value;

            if (cl != null) {
              listLessonResponse.add(LessonResponse(
                  createdAt: cl.endAttendance,
                  startTime: '',
                  endTime: '',
                  attendanceTime: element.timeAttendance,
                  lessonName: cl.nameClass,
                  isPresent: isPresent));
            }
          }
        }

        listResultNamePieChartAbsent = [];
        listResultNamePieChartPresent = [];
        double present = 0;
        double absent = 0;
        double sum = 0;

        for (var element in attendanceInherited!.listClass) {
          present = 0;
          absent = 0;
          var listAttendanceByClass = ref
              .watch(getAttendanceClassByStudentIdAndClassId(
                  AttendanceClassQuery(user.uid, element.id)))
              .value;
          if (listAttendanceByClass != null) {
            for (var element in listAttendanceByClass) {
              if (element.statusAttendance == "present") {
                present++;
              } else {
                absent++;
              }
            }
            sum = present + absent;
            if (sum != 0) {
              if ((present / sum) * 100 >= 70) {
                listResultNamePieChartPresent.add(element.nameClass);
              } else {
                listResultNamePieChartAbsent.add(element.nameClass);
              }
            }
          }
        }

        var dateOfWeek = getDate(attendanceInherited.dateFilter.subtract(
            Duration(days: attendanceInherited.dateFilter.weekday - 1)));
        for (int i = 0; i < 7; i++) {
          double presentWeek = 0;
          double absentWeek = 0;
          String dateWeek = DateFormat("dd-MM-yyyy").format(dateOfWeek);
          var result = (selectIdDropdown == "0")
              ? ref
                  .watch(getAttendanceClassByDateProvider(
                      AttendanceQuery(user.uid, dateWeek)))
                  .value
              : ref
                  .watch(getAttendanceByDateAndClassIdAndStudentId(
                      AttendanceByDateAndObjectIdQuery(
                          user.uid, selectIdDropdown, dateWeek)))
                  .value;

          if (result != null) {
            for (var element in result) {
              if (element.statusAttendance == "present") {
                presentWeek++;
              } else {
                absentWeek++;
              }
            }
          }

          presentData.add({
            '$i': (presentWeek + absentWeek == 0)
                ? 0
                : presentWeek / (presentWeek + absentWeek) * 100
          });
          absentData.add({
            "$i": (presentWeek + absentWeek == 0)
                ? 0
                : absentWeek / (presentWeek + absentWeek) * 100
          });
          dateOfWeek =
              DateTime(dateOfWeek.year, dateOfWeek.month, dateOfWeek.day + 1);
        }
      }
    }
    //get data chart

    print('oooooo ${attendanceInherited!.dateFilter}');
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      children: [
        _studentStatusLayout(
            context, Icons.person_outline, 'TOTAL LESSON', '$totalAllLesson',
            onTap: () => _viewDetails(context, styleTitle,
                listLessonResponse: listLessonResponse)),
        _studentStatusLayout(
            context,
            Icons.person_outline,
            'PRESENT ',
            listLessonResponse
                .filter((x) => x.isPresent == true)
                .length
                .toString(),
            backroundColor: Colors.green,
            onTap: () => _viewDetails(context, styleTitle,
                listLessonResponse: (listLessonResponse == null)
                    ? []
                    : listLessonResponse
                        .filter((x) => x.isPresent == true)
                        .toList())),
        _studentStatusLayout(
            context,
            Icons.person_outline,
            'ABSENT ',
            listLessonResponse
                .filter((x) => x.isPresent != true)
                .length
                .toString(),
            backroundColor: Colors.red,
            onTap: () => _viewDetails(context, styleTitle,
                listLessonResponse: (listLessonResponse == null)
                    ? []
                    : listLessonResponse
                        .filter((x) => x.isPresent != true)
                        .toList())),
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
          child: (selectTitleDropdown == "Nhóm")
              ? BarChartSample2(
                  absentData: absentData,
                  presentData: presentData,
                )
              :Container(
    padding: const EdgeInsets.only( left: 10,
    right: 18,
    top: 18,
    bottom: 4,),
    margin:const  EdgeInsets.only(top: 20),
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
    ]
    ),
    child: ref
                  .watch((selectIdDropdown != "0")
                      ? findAllAttendanceBySubjectIdAndStudentIdProvider(
                          AttendanceClassQuery(user.uid, selectIdDropdown))
                      : getAllAttendanceByStudentId(user.uid))
                  .when(
                      data: (data) {
                        List<SubjectModel> subjects=[];
                        var subject;
                        data.forEach((element) {
                          subject = ref.watch(getSubjectByIdProvider(element.idSubject)).value;
                          if(subject != null && !subjects.contains(subject)){
                            subjects.add(subject);
                          }
                        });

                        return ListView.builder(
                            itemCount: subjects.length,
                            itemBuilder: (context, index) {
                              var presentS = data.filter((t) => t.statusAttendance == "present" && t.idSubject == subjects[index].id && t.idStudent == user.uid);
                              return ListTile(
                                title: Text(subjects[index].nameSubject),
                                subtitle: Text(subjects[index].nameTeacher),
                                leading: CircleAvatar(
                                  child: Text("${subjects[index].lessons.length}"),
                                ),
                                trailing: Container(
                                  padding:const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: Text("${presentS.length / subjects[index].lessons.length * 100}%"),
                                ),
                              );
                            });
                      },
                      error: (error, stackTrace) =>
                          ErrorScreen(text: error.toString()),
                      loading: () => const Loader()),
        )),
        _showListSubject(context, listResultNamePieChartAbsent,
            percent: '> 30%', background: Colors.red),
        _showListSubject(context, listResultNamePieChartPresent,
            percent: '< 70%', background: Colors.green),
      ],
    );
  }

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

  _showLessonLayout(
          {required String lesson,
          required String attendanceCreated,
          required String attendanceTime,
          required bool present}) =>
      ListTile(
        leading: (present)
            ? const Icon(
                Icons.verified,
                color: Colors.green,
              )
            : const Icon(
                Icons.close,
                color: Colors.red,
              ),
        title: Text(lesson),
        subtitle: Text(attendanceCreated),
        trailing: Text(attendanceTime),
      );

  _showListSubject(context, List<String> listSubject,
          {required String percent, required Color background}) =>
      Container(
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(
              backgroundColor: background,
              radius: MediaQuery.of(context).size.width * 0.08,
              child: Text(
                percent,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: (listSubject.isEmpty)
                  ? Text(selectTitleDropdown,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))
                  : ListView.builder(
                      itemCount: listSubject.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectTitleDropdown,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(listSubject.elementAt(index))
                            ],
                          );
                        } else {
                          return Text(listSubject.elementAt(index));
                        }
                      }),
            )
          ],
        ),
      );

  _viewDetails(context, styleTitle,
          {List<LessonResponse>? listLessonResponse,
          List<SubjectResponse>? listSubjectResponse}) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: Row(
              children: [
                Expanded(
                    child: Text(
                  'TOTAL LESSON of ${selectTitleDropdown.toUpperCase()} ${selectValueDropdown.toUpperCase()}',
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
                      Text("$selectTitleDropdown/", style: styleTitle),
                      const Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "created",
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
              width: MediaQuery.of(context).size.width / 2,
              child: (listSubjectResponse == null)
                  ? (listLessonResponse == null)
                      ? const Center(
                          child: Text('NULL'),
                        )
                      : ListView.builder(
                          itemCount: listLessonResponse.length,
                          itemBuilder: (context, index) {
                            return _showLessonLayout(
                                lesson: listLessonResponse[index].lessonName,
                                attendanceCreated:
                                    "${listLessonResponse[index].createdAt} ${listLessonResponse[index].startTime} - ${listLessonResponse[index].endTime}",
                                attendanceTime:
                                    listLessonResponse[index].attendanceTime,
                                present: listLessonResponse[index].isPresent);
                          })
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: listSubjectResponse.length,
                      itemBuilder: (context, index) {
                        var subject = listSubjectResponse[index];
                        return Column(
                          children: [
                            Text(subject.subjectName),
                            const SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: subject.lessonResponse.length,
                                itemBuilder: (context, index) {
                                  return _showLessonLayout(
                                      lesson: subject
                                          .lessonResponse[index].lessonName,
                                      attendanceCreated:
                                          "${subject.lessonResponse[index].startTime} - ${subject.lessonResponse[index].endTime}",
                                      attendanceTime: subject
                                          .lessonResponse[index].attendanceTime,
                                      present: subject
                                          .lessonResponse[index].isPresent);
                                })
                          ],
                        );
                      }),
            ),
          );
        },
      );
}
