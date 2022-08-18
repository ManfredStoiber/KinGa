import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinga/ui/AttendanceScreen.dart';
import 'firebase_options.dart';
import 'package:kinga/data/FirebaseStudentRepository.dart';
import 'package:kinga/domain/StudentService.dart';
import '../constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GetIt.I.registerSingleton<StudentService>(StudentService(FirebaseStudentRepository()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: ColorSchemes.kingacolor,
        scaffoldBackgroundColor: ColorSchemes.backgroundColor,
        backgroundColor: ColorSchemes.backgroundColor,
        errorColor: ColorSchemes.errorColor
      ),
      home: const AttendanceScreen(),
    );
  }
}
