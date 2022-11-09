import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/data/firebase_student_repository.dart';
import 'package:kinga/injection.dart';
import 'package:kinga/ui/attendance_screen.dart';
import 'package:kinga/ui/setup_account_screen.dart';
import 'package:kinga/ui/setup_institution_screen.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'domain/students_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // StreamBuilder for distinction if user is authenticated or not
    return StreamBuilder<User?>(
      stream: GetIt.instance.get<FirebaseAuth>().authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          return PreferenceBuilder(preference: GetIt.instance.get<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: ""),
              builder: (BuildContext context, String institutionId) {
                // if logged in

                // check if user is already in an institution
                if (institutionId != "") {
                  // if in institution
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
                      home: const AttendanceScreen(),
                    ),
                  );
                } else {
                  // if not in institution
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
                      home: const SetupInstitutionScreen(),
                    ),
                  );
                }
              }
          );
        } else {
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
              home: const SetupAccountScreen(),
            ),
          );
        }
      },
    );
  }
}