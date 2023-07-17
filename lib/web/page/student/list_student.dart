import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/attendance/controller/attendance_controller.dart';
import 'package:attendance_/web/page/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../common/widgets/error_text.dart';
import '../../../common/widgets/loading_page.dart';
import '../auth/controller/auth_controller.dart';

class ListStudent extends ConsumerStatefulWidget {
  const ListStudent({
    Key? key,
    required this.selectValueDropdown,
    required this.selectIdDropdown,
    required this.selectTitleDropdown,
  }) : super(key: key);
  final String selectValueDropdown;
  final String selectIdDropdown;
  final String selectTitleDropdown;

  @override
  ConsumerState<ListStudent> createState() => _ListStudentState();
}

class _ListStudentState extends ConsumerState<ListStudent> {
  @override
  Widget build(BuildContext context) {
    List<UserModel> users = [];
    var user = ref.watch(userProvider)!;

    var attendances = (widget.selectIdDropdown == "0")
        ? ref.watch(getAttendanceByNameCreatorClass(user.name))
        : ref.watch(getAttendanceByClassProvider(widget.selectIdDropdown));
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 18,
        top: 18,
        bottom: 4,
      ),
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
      child: attendances.when(
        data: (listAttendance) {
          for (var cl in listAttendance) {
            var student = ref.watch(getUserDataById(cl.idStudent)).value;
            if (student != null && !users.contains(student)) {
              users.add(student);
            }
          }

          return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                if (users[index] == null) {
                  return const CircularProgressIndicator();
                }
                var present = listAttendance.filter((x) =>
                    x.idStudent == users[index].uid &&
                    x.statusAttendance == "present");
                var total = listAttendance
                    .filter((x) => x.idStudent == users[index].uid);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _avatarLayout(users[index].name[0].toUpperCase(),
                              users[index].isOnline),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                users[index].name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                users[index].phoneNumber,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              '${(present.length / total.length * 100).round()}%',
                              style: const TextStyle(
                                  fontSize: 18, fontStyle: FontStyle.italic),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("${total.length} ${widget.selectTitleDropdown}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))
                        ],
                      ),
                      const Row(
                        children: [
                          Text('Message'),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.message_outlined,
                            color: Colors.blue,
                          )
                        ],
                      )
                    ],
                  ),
                );
              });
        },
        error: (error, stackTrace) => ErrorScreen(text: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }

  _avatarLayout(String urlImage, bool statusOnline) => Stack(children: [
        CircleAvatar(
          backgroundColor: const Color(0xff00A3FF),
          radius: 35.0,
          child: Text(urlImage.toUpperCase()),
        ),
        Positioned(
            right: 0,
            bottom: 0,
            child: Container(
                padding: const EdgeInsets.all(7.5),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.circular(90.0),
                    color: (statusOnline) ? Colors.green : Colors.grey)))
      ]);
}
