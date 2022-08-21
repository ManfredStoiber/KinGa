import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/entity/student.dart';

part '../domain/students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {

  final StudentRepository studentRepository;

  StudentsCubit(this.studentRepository) : super(StudentsInitial());

  Future<void> getStudents() async {
    emit(StudentsLoading());
    final students = await studentRepository.getAllStudents();
    emit(StudentsLoaded(students, null));
  }

  Future<void> toggleAttendance(String studentId) async {
    // TODO
    if (state is StudentsLoaded) {
      String now = DateTime.now().toIso8601String();
      (state as StudentsLoaded).getStudent(studentId).attendances.add(Attendance(now.substring(0, 10), now.substring(11, 16)));
      emit(StudentsLoaded((state as StudentsLoaded).students, (state as StudentsLoaded).selected));
    }
  }

}
