import 'package:flutter/material.dart';

import 'package:kinga/ui/edit_student_screen.dart';


class NewStudentScreen extends StatefulWidget {
  const NewStudentScreen({Key? key}) : super(key: key);

  @override
  State<NewStudentScreen> createState() => _NewStudentScreenState();
}

class _NewStudentScreenState extends State<NewStudentScreen> {

  @override
  Widget build(BuildContext context) {
    return EditStudentScreen();
  }
}