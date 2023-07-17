import 'package:attendance_/models/class_model/class_model.dart';
import 'package:attendance_/models/subjects_model/subject_model.dart';
import 'package:attendance_/pages/attendance/controller/attendance_controller.dart';
import 'package:attendance_/web/page/auth/controller/auth_controller.dart';
import 'package:attendance_/web/page/auth/provider/auth_provider.dart';
import 'package:attendance_/web/page/manage_attendance/manage_attendance.dart';
import 'package:attendance_/web/page/my_attendance/attendance_inherited.dart';
import 'package:attendance_/web/page/my_attendance/my_attendance.dart';
import 'package:attendance_/web/page/student/list_student.dart';
import 'package:attendance_/web/page/welcome/welcome_screen.dart';
import 'package:attendance_/web/page/widget/public/type_dropdown_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../common/routes/routes.dart';
import '../common/values/theme.dart';
import '../common/widgets/error_text.dart';
import '../common/widgets/loading_page.dart';
import '../firebase_options.dart';
import '../models/user_model/user_model.dart';
import '../pages/class_and_subject/class/controller/class_controller.dart';
import '../pages/class_and_subject/subject/controller/subject_controller.dart';

void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) => Material(
        color: Colors.green.shade200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              details.exception.toString(),
              style: TextStyle(
                  color: AppTheme.background,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp),
            ),
          ),
        ),
      );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref.watch(authControllerProvider.notifier).getUserData();

    ref.watch(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: AppTheme.background,
          ),
          debugShowCheckedModeBanner: false,
          title: 'A T T E N D A N C E',
          home: child,
          onGenerateRoute: (settings) => generateRoute(settings),
        );
      },
      child: ref.watch(authStateChangeProvider).when(
            data: (data) {
              if (data != null) {
                getData(ref, data);
                final user = ref.watch(userProvider);
                if (user != null) {
                  // ref.read(authControllerProvider.notifier).setUserState(true);
                  return const MyHomePage();
                }
              }
              return const WelcomeScreen();
            },
            error: (error, stackTrace) => ErrorScreen(text: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  static const routeName = "home-web";

  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final double heightTopContainer = 150;
  final paddingContent = const EdgeInsets.symmetric(horizontal: 60);
  TextStyle styleTabBar =
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

  late String _selectTitleDropdown = 'Chủ đề';
  late String _selectSubjectName = 'Tất cả';
  late String _selectClassName = 'Tất cả';

  String subjectId = "0";
  String classId = "0";

  DateTime now = DateTime.now();
  DateTime selectedDate = DateTime.now();
  int _currentIndex = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<SubjectModel> listSubject = [];
    List<ClassModel> listClass = [];
    List<Map<String, String>>? listTopicsResponse = [
      {'0': "Tất cả"}
    ];
    List<Map<String, String>>? listGroupResponse = [
      {'0': "Tất cả"}
    ];
    final widthContent = MediaQuery.of(context).size.width;
    final user = ref.watch(userProvider)!;

    TextEditingController _controllerSearch = TextEditingController();

    if (_currentIndex == 0) {
      listTopicsResponse = [{'0': "Tất cả"}];
      listGroupResponse = [{'0': "Tất cả"}];
      ref.watch(getAllAttendanceByStudentId(user.uid)).whenData((value) {
        listSubject = [];
        value.forEach((element) {
          var subject = ref.watch(getSubjectByIdProvider(element.idSubject)).value;
          if (!listSubject.contains(subject) && subject!=null) {
            listSubject.add(subject);
            listTopicsResponse!.add({subject.id: subject.nameSubject});
          }
        });
      });

      var getAttendanceForClass = ref.watch(getAttendanceClassByStudentIdProvider(user.uid));
      if(getAttendanceForClass != null){
        getAttendanceForClass.whenData((value) {
          value.forEach((element) {
            var clasS = ref.watch(getClassByIdProvider(element.idClass)).value;
            if(clasS != null){
              listClass.add(clasS);
              listGroupResponse!.add({clasS.id: clasS.nameClass});
            }
          });
        });
      }

    }
    else {
      listTopicsResponse = [
        {'0': "Tất cả"}
      ];
      listGroupResponse = [
        {'0': "Tất cả"}
      ];
      var subjects = ref.watch(getSubjectProvider(user.uid)).value;
      var getClass = ref.watch(getClassProvider(user.uid)).value;
      if (subjects != null) {
        subjects.forEach((element) {
          listTopicsResponse!.add({element.id: element.nameSubject});
        });
      }
      if (getClass != null) {
        getClass.forEach((element) {
          listGroupResponse!.add({element.id: element.nameClass});
        });
      }
    }

    return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(18, 25, 39, 1),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: TabBar(
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.white,
                      indicatorColor: Colors.green,
                      indicatorWeight: 3,
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                          _selectClassName = "Tất cả";
                          _selectSubjectName = "Tất cả";
                        });
                      },
                      labelPadding: const EdgeInsets.all(5),
                      tabs: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Icon(Icons.access_time_outlined),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              ' Attendance',
                              style: styleTabBar,
                            ),
                          ],
                        ),
                        Text(
                          "Manage Attendance",
                          style: styleTabBar,
                        ),
                        Text(
                          "Student's List",
                          style: styleTabBar,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: TextField(
                            controller: _controllerSearch,
                            readOnly: _currentIndex == 0,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                                hintText: 'Enter a search term',
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(50)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                       CircleAvatar(
                        child: Text(user.name[0].toUpperCase()),
                      ),
                      TextButton(
                          onPressed: () {},
                          child:  Row(
                            children: [
                              Text(user.name),
                              const Icon(Icons.arrow_drop_down)
                            ],
                          ))
                    ],
                  ))
                ],
              ),
            ),
            backgroundColor: const Color.fromRGBO(242, 243, 247, 1),
            body: Stack(
              children: [
                Container(
                  height: heightTopContainer,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(18, 25, 39, 1),
                  ),
                ),
                Container(
                  padding: paddingContent,
                  width: widthContent,
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                       Expanded(
                          child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Hello! ${user.name}',
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                //title
                                DropdownButton(
                                    underline: Container(),
                                    value: _selectTitleDropdown,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    dropdownColor: Colors.black,
                                    items: filters
                                        .map<DropdownMenuItem<String>>((e) {
                                      return DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectTitleDropdown = value!;
                                      });
                                    }),
                                //value
                                (_selectTitleDropdown == filters.first)
                                    ? DropdownButton(
                                        underline: Container(),
                                        value: _selectSubjectName,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        dropdownColor: Colors.black,
                                        items: listTopicsResponse!
                                            .map<DropdownMenuItem<String>>((e) {
                                          return DropdownMenuItem<String>(
                                            value: e.values.last,
                                            child: Text(
                                              e.values.last,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                subjectId = e.keys.first;
                                              });
                                            },
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectSubjectName = value!;
                                          });
                                        })
                                    : DropdownButton(
                                        underline: Container(),
                                        value: _selectClassName,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        dropdownColor: Colors.black,
                                        items: listGroupResponse
                                            .map<DropdownMenuItem<String>>((e) {
                                          return DropdownMenuItem<String>(
                                            value: e.values.last,
                                            child: Text(
                                              e.values.last,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                classId = e.keys.first;
                                              });
                                            },
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectClassName = value!;
                                          });
                                        })
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                                onPressed: () => _selectDate(context),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Ngày: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(
                                        DateFormat("dd-MM-yyyy")
                                            .format(selectedDate),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        )),
                                    const Icon(Icons.date_range_sharp)
                                  ],
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: widthContent,
                  padding: paddingContent,
                  margin: EdgeInsets.only(top: (heightTopContainer - 40)),
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(child:  AttendanceInherited(
                        listSubject: listSubject,
                        dateFilter: selectedDate,
                        listClass: listClass,
                        child: MyAttendanceScreen(
                          selectValueDropdown:
                          (_selectTitleDropdown == filters.first)
                              ? _selectSubjectName
                              : _selectClassName,
                          selectIdDropdown:
                          (_selectTitleDropdown == filters.first)
                              ? subjectId
                              : classId,
                          selectTitleDropdown: _selectTitleDropdown,
                        ),
                      ),
                          ),
                     SingleChildScrollView(
                       child:  ManageAttendanceScreen(
                         selectValueDropdown:
                         (_selectTitleDropdown == filters.first)
                             ? _selectSubjectName
                             : _selectClassName,
                         selectIdDropdown:
                         (_selectTitleDropdown == filters.first)
                             ? subjectId
                             : classId,
                         selectTitleDropdown: _selectTitleDropdown, selectDate: selectedDate,),
                     ),
                      ListStudent(selectValueDropdown:
                      (_selectTitleDropdown == filters.first)
                          ? _selectSubjectName
                          : _selectClassName,
                        selectIdDropdown:
                        (_selectTitleDropdown == filters.first)
                            ? subjectId
                            : classId,
                        selectTitleDropdown: _selectTitleDropdown,),
                    ],
                  ),
                ),
              ],
            )));
  }
}
