import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/data/firebase_student_repository.dart';
import 'package:kinga/ui/attendance_screen.dart';
import 'package:kinga/ui/setup_screen.dart';
import 'package:kinga/ui/tabtest.dart';
import 'domain/students_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // StreamBuilder for distinction if user is authenticated or not
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          // if logged in
          return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => StudentsCubit(FirebaseStudentRepository()),
                  child: const AttendanceScreen(),
                )
              ],
              child: MaterialApp(
                title: 'Flutter Demo',
                localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: ColorSchemes.kingacolor,
        scaffoldBackgroundColor: ColorSchemes.backgroundColor,
        backgroundColor: ColorSchemes.backgroundColor,
        errorColor: ColorSchemes.errorColor
      ),
      home: const AttendanceScreen(),
    ),
);} else {
          // if not logged in
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => StudentsCubit(FirebaseStudentRepository()),
                child: const AttendanceScreen(),
              )
            ],
            child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                // This is the theme of your application.
                  primarySwatch: ColorSchemes.kingacolor,
                  scaffoldBackgroundColor: ColorSchemes.backgroundColor,
                  backgroundColor: ColorSchemes.backgroundColor,
                  errorColor: ColorSchemes.errorColor
              ),
              home: const SetupScreen(),
            ),
          );
        }
      },
    );
  }
}