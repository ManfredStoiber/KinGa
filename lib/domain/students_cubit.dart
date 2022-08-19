import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:kinga/domain/StudentRepository.dart';

import 'entity/Student.dart';

part '../domain/students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {

  final StudentRepository studentRepository;

  StudentsCubit(this.studentRepository) : super(StudentsInitial());

  Future<void> getStudents() async {
    emit(StudentsLoading());
    final students = await studentRepository.getAllStudents();
    emit(StudentsLoaded(students, null));
  }

}
