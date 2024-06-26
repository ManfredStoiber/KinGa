import 'package:flutter/material.dart';

class ColorSchemes {
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
  // static const int _kingacolorSecondaryValue = 0xFFE5B5A0;

  static const MaterialColor kingacolorAccent = MaterialColor(_kingacolorAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_kingacolorAccentValue),
    400: Color(0xFFB0FFCF),
    700: Color(0xFF96FFC0),
  });
  static const int _kingacolorAccentValue = 0xFF8AFFFF;

  static const Color backgroundColor = Color.fromARGB(255, 254, 233, 214);
  static const Color errorColor = Color.fromARGB(255, 229, 91, 160);
  static const Color errorColorLight = Color(0xFFFDBAB6);
  static const Color attendantColor = kingacolor;
  static const Color notAttendantColor = Color.fromARGB(255, 200, 200, 200);
  //static const Color notAttendantColor = absentColor;
  //static const Color absentColor = Color.fromARGB(255, 132, 91, 229);
  //static const Color absentColor = Color(0xFFA053FF);
  static const Color absentColor = errorColor;
  static const Color kingaGrey = Color.fromARGB(255, 200, 200, 200);



  static const Color categoryColor = Color(0xFF03A9F4);
  static const Color categoryColorLight = Color(0xFFB3E5FC);

  static const Color textColorLight = Color(0xA0424242);
}