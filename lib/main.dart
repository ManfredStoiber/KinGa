import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kinga/constants/colors.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/routes.dart';
import 'package:kinga/domain/authentication_service.dart';
import 'package:kinga/features/commons/domain/analytics_service.dart';
import 'package:kinga/features/permissions/ui/create_permission_screen.dart';
import 'package:kinga/features/permissions/ui/list_permissions_screen.dart';
import 'package:kinga/features/permissions/ui/show_permission_screen.dart';
import 'package:kinga/injection.dart';
import 'package:kinga/ui/attendance_screen.dart';
import 'package:kinga/ui/setup_account_screen.dart';
import 'package:kinga/ui/setup_institution_screen.dart';
import 'package:kinga/ui/show_student_screen.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'ui/bloc/students_cubit.dart';

final router = GoRouter(

  redirect: (context, state) {
    if (GetIt.I<AuthenticationService>().getCurrentUser() == null) {
      return '/${Routes.setupAccount}';
    }
    if (GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: "").getValue() == '') {
      return '/${Routes.setupInstitution}';
    }
    if (state.location == '/${Routes.attendance}') {
      return '/';
    }
    if (state.location == '/${Routes.student}') {
      return '/';
    }
    if (state.location == Routes.reset) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
        path: '/',
        name: Routes.home,
        builder: (context, state) {
          return const AttendanceScreen();
        },
      routes: [
        GoRoute(
          path: 'permission',
          name: Routes.listPermissions,
          builder: (context, state) {
            return const ListPermissionsScreen();
          },
          routes: [
            GoRoute(
              path: 'permission/:permission',
              name: Routes.showPermission,
              builder: (context, state) {
                var permission = (state.pathParameters['permission']);
                return ShowPermissionScreen(permission!);
              },
            ),
            GoRoute(
              path: 'createPermission',
              name: Routes.createPermission,
              builder: (context, state) {
                return const CreatePermissionScreen();
              },
            ),
          ]
        ),
        GoRoute(
          path: 'student/:studentId',
          name: Routes.student,
          builder: (context, state) {
            var studentId = (state.pathParameters['studentId']);
            if (studentId == null) {
              return Container();
            }
            return ShowStudentScreen(studentId: studentId, initialTab: state.queryParameters['show']);
          },
        ),
      ]
    ),
    GoRoute(
      path: '/${Routes.setupAccount}',
      name: Routes.setupAccount,
      builder: (context, state) => const SetupAccountScreen(),
    ),
    GoRoute(
      path: '/${Routes.setupInstitution}',
      name: Routes.setupInstitution,
      builder: (context, state) => const SetupInstitutionScreen(),
    ),
  ]
);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // configure dependencies
  await configureDependencies();

  //Setting SysemUIOverlay
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark)
  );

  //Setting SystmeUIMode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.top]);
  if (!(Platform.isWindows || Platform.isLinux)) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  //runApp(MyApp(studentService, authenticationService));
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsResumed);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsResumed);
    } else if (state == AppLifecycleState.paused) {
      GetIt.I<AnalyticsService>().logEvent(name: Keys.analyticsPaused);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentsCubit(),
      child: MaterialApp.router(
        routerConfig: router,
        title: 'KinGa',
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
          cardTheme: CardTheme.of(context).copyWith(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: ColorSchemes.kingaGrey,
                width: 3.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            )
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: ColorSchemes.kingacolor).copyWith(
            error: ColorSchemes.errorColor,
            background: ColorSchemes.backgroundColor
          )
        ),
      ),
    );
  }
}