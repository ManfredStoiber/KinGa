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
  static const int _kingacolorSecondaryValue = 0xFFE5B5A0;

  static const MaterialColor kingacolorAccent = MaterialColor(_kingacolorAccentValue, <int, Color>{
    100: Color(0xFFFFFFFF),
    200: Color(_kingacolorAccentValue),
    400: Color(0xFFB0FFCF),
    700: Color(0xFF96FFC0),
  });
  static const int _kingacolorAccentValue = 0xFFE3FFEE;

  static const Color backgroundColor = Color.fromARGB(255, 254, 233, 214);
  static const Color errorColor = Color.fromARGB(255, 229, 91, 160);
  static const Color attendantColor = kingacolor;
  static const Color notAttendantColor = errorColor;
  static const Color absentColor = Color.fromARGB(255, 132, 91, 229);
}