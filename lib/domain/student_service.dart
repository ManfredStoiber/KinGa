import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/util/date_utils.dart';

class StudentService {

  final StudentRepository _studentRepository = GetIt.I<StudentRepository>();
  late Stream<Set<Student>> studentStream;
  late Set<Student> students;
  late Set<String> groups;

  StudentService() {
    studentStream = _studentRepository.watchStudents().map((students) {
      this.students = students;
      Set<String> tmp = {};
      for (var student in students) {
        tmp.add(student.group);
      }
      groups = tmp;
      return students;
    });
  }

  Stream<Set<Student>> watchStudents() {
    return studentStream;
  }

  Student getStudent(String studentId) {
    return students.firstWhere((student) => student.studentId == studentId);
  }

  Future<void> updateStudent(Student student) async {
    _studentRepository.updateStudent(student);
  }

  void createStudent(Map<String, dynamic> student, Uint8List profileImage) {
    _studentRepository.createStudent(
        student['firstname'],
        student['middlename'],
        student['lastname'],
        student['birthday'],
        student['street'],
        student['housenumber'],
        student['postcode'],
        student['city'],
        profileImage,
        student['caregivers']);
  }

  Future<void> toggleAttendance(String studentId) async {

    if (isAbsent(studentId)) {
      // if absent, do nothing
      return;
    }

    String now = DateTime.now().toIso8601String();
    String currentDate = IsoDateUtils.getIsoDateFromIsoDateTime(now);
    String currentTime = IsoDateUtils.getIsoTimeFromIsoDateTime(now);

    List<Attendance> attendances = getStudent(studentId).attendances;

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
    updateStudent(getStudent(studentId));
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

  Attendance? getAttendanceOfToday(List<Attendance> attendances) {
    for (var attendance in attendances) {
      if (attendance.date == IsoDateUtils.getIsoDateFromIsoDateTime(DateTime.now().toIso8601String())) {
        return attendance;
      }
    }
    return null;
  }

  bool isAttendant(String studentId) {
    Attendance? attendance = getAttendanceOfToday(getStudent(studentId).attendances);
    if (attendance == null) {
      return false;
    } else {
      return attendance.leaving == null;
    }
  }

  bool hasBirthday(String studentId) {
    return IsoDateUtils.getIsoDateFromIsoDateTime(
        DateTime.now().toIso8601String()).substring(5) == getStudent(studentId)
        .birthday.substring(5);
  }

  void setProfileImage(String studentId, Uint8List image) {
    _studentRepository.setProfileImage(studentId, image);
  }

  bool isAbsent(String studentId) {
    return getAbsencesOfToday(getStudent(studentId).absences).isNotEmpty;
  }

  Future<void> createAbsence(String studentId, Absence absence) async {
    _studentRepository.createAbsence(studentId, absence);
  }

}