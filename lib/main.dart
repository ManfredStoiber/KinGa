import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kinga/ui/AttendanceScreen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:kinga/data/FirebaseStudentRepository.dart';
import 'package:kinga/domain/StudentService.dart';

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

  static const MaterialColor kingacolor = MaterialColor(_kingacolorPrimaryValue, <int, Color>{
    50: Color(0xFFEBFCF4),
    100: Color(0xFFCEF7E3),
    200: Color(0xFFADF2D0),
    300: Color(0xFF8CEDBD),
    400: Color(0xFF74E9AE),
    500: Color(_kingacolorPrimaryValue),
    600: Color(0xFF53E298),
    700: Color(0xFF49DE8E),
    800: Color(0xFF40DA84),
    900: Color(0xFF2FD373),
  });
  static const int _kingacolorPrimaryValue = 0xFF5BE5A0;
  static const int _kingacolorSecondaryValue = 0xFFE5B5A0;

  static const MaterialColor kingacolorAccent = MaterialColor(_kingacolorAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_kingacolorAccentValue),
    400: Color(0xFFB0FFCF),
    700: Color(0xFF96FFC0),
  });
  static const int _kingacolorAccentValue = 0xFFE3FFEE;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: kingacolor,
        scaffoldBackgroundColor: Color.fromARGB(255, 254, 233, 214),
        backgroundColor: Color.fromARGB(255, 254, 233, 214),
        errorColor: Color.fromARGB(255, 229, 91, 160)
      ),
      home: const AttendanceScreen(),
    );
  }
}
