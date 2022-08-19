import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinga/data/FirebaseStudentRepository.dart';
import 'package:kinga/ui/AttendanceScreen.dart';
import 'domain/students_cubit.dart';
import 'firebase_options.dart';
import '../constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StudentsCubit(FirebaseStudentRepository())..getStudents(),
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
  }
}
