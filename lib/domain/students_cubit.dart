import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/util/date_utils.dart';

part '../domain/students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {

  final StudentRepository studentRepository;

  StudentsCubit(this.studentRepository) : super(StudentsInitial()) {
    studentRepository.watchStudents().listen((students) {
      emit(StudentsLoaded(students, null));
    });
  }

  Future<void> toggleAttendance(String studentId) async {
    if (state is StudentsLoaded) {
      if (isAbsent(studentId)) {
        // if absent, do nothing
        return;
      }
      String now = DateTime.now().toIso8601String();
      String currentDate = IsoDateUtils.getIsoDateFromIsoDateTime(now);
      String currentTime = IsoDateUtils.getIsoTimeFromIsoDateTime(now);

      List<Attendance> attendances = (state as StudentsLoaded).getStudent(studentId).attendances;

      // check if there is already an attendance for today
      Attendance? attendanceOfToday = getAttendanceOfToday(attendances);
      if (attendanceOfToday != null) {
        // if yes, check if student has already left
        if (attendanceOfToday.leaving != null) {
          // remove last leave
          attendanceOfToday.leaving = null;
        } else {
          // else check if student came within the last 5 minutes
          DateTime coming = DateTime.parse('${attendanceOfToday.date}T${attendanceOfToday.coming}');
          if (coming.add(Duration(minutes: 5)).isAfter(DateTime.now())) {
            // within last 5 minutes --> undo coming
            attendances.remove(attendanceOfToday);
          } else {
            // longer than 5 minutes --> leave
            attendanceOfToday.leaving = currentTime;
          }
        }
      } else {
        // if no, add new attendance
        attendances.add(Attendance(currentDate, currentTime));
      }
      studentRepository.updateStudent((state as StudentsLoaded).getStudent(studentId));
      emit(StudentsLoaded((state as StudentsLoaded).students, (state as StudentsLoaded).selected));
    }
  }

  Attendance? getAttendanceOfToday(List<Attendance> attendances) {
    for (var attendance in attendances) {
      if (attendance.date == IsoDateUtils.getIsoDateFromIsoDateTime(DateTime.now().toIso8601String())) {
        return attendance;
      }
    }
    return null;
  }

  Set<Absence> getAbsencesOfToday(List<Absence> absences) {
    Set<Absence> absencesOfToday = {};
    for (var absence in absences) {
      DateTime from = DateTime.parse(absence.from);
      DateTime until = DateTime.parse(absence.until);
      DateTime now = DateTime.now();

      if (now.isAfter(from) && now.isBefore(until.add(Duration(days: 1)))) {
        absencesOfToday.add(absence);
      }
    }
    return absencesOfToday;
  }


  bool isAttendant(String studentId) {
    if (state is StudentsLoaded) {
      Attendance? attendance = getAttendanceOfToday((state as StudentsLoaded).getStudent(studentId).attendances);
      if (attendance == null) {
        return false;
      } else {
        return attendance.leaving == null;
      }
    }
    return false;
  }

  bool isAbsent(String studentId) {
    if (state is StudentsLoaded) {
      return getAbsencesOfToday((state as StudentsLoaded).getStudent(studentId).absences).isNotEmpty;
    }
    return false;
  }

  Future<void> createAbsence(String studentId, Absence absence) async {
    studentRepository.createAbsence(studentId, absence);
  }

}
