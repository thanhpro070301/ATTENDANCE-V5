import 'package:attendance_/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:attendance_/common/routes/routes.dart';
import 'package:attendance_/common/values/theme.dart';
import 'package:attendance_/common/widgets/error_text.dart';
import 'package:attendance_/common/widgets/loading_page.dart';
import 'package:attendance_/models/user_model/user_model.dart';
import 'package:attendance_/pages/app_home_chatscreen/app_home_screen.dart';
import 'package:attendance_/pages/auth/controller/auth_controller.dart';
import 'package:attendance_/pages/auth/provider/auth_provider.dart';
import 'package:attendance_/pages/welcome/welcome_screen.dart';

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
                fontSize: 17.sp,
              ),
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
  void getData(WidgetRef ref) async {
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
              textTheme: AppTheme.textTheme),
          debugShowCheckedModeBanner: false,
          title: 'A T T E N D A N C E',
          home: child,
          onGenerateRoute: (settings) => generateRoute(settings),
        );
      },
      child: ref.watch(authStateChangeProvider).when(
            data: (data) {
              if (data != null) {
                getData(ref);
                final user = ref.watch(userProvider);
                if (user != null) {
                  return const AppHomeScreen();
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
