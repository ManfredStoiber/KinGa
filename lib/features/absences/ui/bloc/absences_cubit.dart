import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:table_calendar/table_calendar.dart';

part 'absences_state.dart';

class AbsencesCubit extends Cubit<AbsencesState> {

  final StudentService _studentService = GetIt.I<StudentService>();
  StreamSubscription<Set<Student>>? _streamSubscription;

  String studentId;

  AbsencesCubit(this.studentId) : super(AbsencesInitial()) {
    emit(AbsencesLoading());
    emit(AbsencesLoaded(_studentService.students.firstWhere((student) => student.studentId == studentId), DateTime.now()));
    _streamSubscription = _studentService.watchStudents().listen((students) {
      if (state is AbsencesLoaded) {
        Student? student = students.cast<Student?>().firstWhere((student) => student!.studentId == studentId, orElse: () => null);
        if (student != null) {
          emit(AbsencesLoaded(student, (state as AbsencesLoaded).selectedDay));
        } else {
          emit(AbsencesError());
        }
      }
    });
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    super.close();
  }

  void changeSelectedDay(DateTime selectedDay) {
    if (state is AbsencesLoaded) {
      emit(AbsencesLoaded((state as AbsencesLoaded).student, selectedDay));
    }
  }

  bool hasBirthday(String studentId) {
    return _studentService.hasBirthday(studentId);
  }

  bool isAbsent(String studentId) {
    return getAbsencesOfToday(_studentService.getStudent(studentId).absences).isNotEmpty;
  }

  Future<void> createAbsence(String studentId, Absence absence) async {
    _studentService.createAbsence(studentId, absence);
  }

  Future<void> removeAbsence(String studentId, Absence absence) async {
    _studentService.removeAbsence(studentId, absence);
  }

  List<Absence> getAbsencesOfToday(List<Absence> absences) {
    return _studentService.getAbsencesOfToday(absences);
  }

  List<Absence> getAbsencesOfDay(List<Absence> absences, DateTime date) {
    return _studentService.getAbsencesOfDay(absences, date);
  }

}
