import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/domain/authentication_service.dart';
import 'package:kinga/domain/entity/user.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/features/permissions/ui/list_permissions_screen.dart';
import 'package:kinga/features/permissions/ui/show_permission_screen.dart';
import 'package:kinga/injection.dart';
import 'package:kinga/ui/attendance_screen.dart';
import 'package:kinga/ui/setup_account_screen.dart';
import 'package:kinga/ui/setup_institution_screen.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'ui/bloc/students_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // configure dependencies
  await configureDependencies();

  final StudentService studentService = GetIt.I<StudentService>();
  final AuthenticationService authenticationService = GetIt.I<AuthenticationService>();
  runApp(MyApp(studentService, authenticationService));
}

class MyApp extends StatelessWidget {

  final StudentService _studentService;
  final AuthenticationService _authenticationService;

  const MyApp(this._studentService, this._authenticationService, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // StreamBuilder for distinction if user is authenticated or not
    return StreamBuilder<User?>(
      stream: _authenticationService.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          // if logged in
          return PreferenceBuilder(preference: GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: ""),
              builder: (BuildContext context, String institutionId) {
                // reconfigure dependencies
                //reconfigureDependencies();
                // check if user is already in an institution
                if (institutionId != "") {
                  // if in institution
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => StudentsCubit(_studentService),
                        child: const AttendanceScreen(),
                      ),
                    ],
                    child: MaterialApp(
                      title: 'Flutter Demo',
                      localizationsDelegates: const [
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
                        errorColor: ColorSchemes.errorColor,
                        cardTheme: CardTheme.of(context).copyWith(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: ColorSchemes.absentColor,
                              width: 3.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          )
                        )
                      ),
                      home: const AttendanceScreen(),
                    ),
                  );
                } else {
                  // if not in institution
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => StudentsCubit(_studentService),
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
                create: (context) => StudentsCubit(_studentService),
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