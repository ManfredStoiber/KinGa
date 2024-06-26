import 'dart:collection';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/util/date_utils.dart';
import 'package:kinga/util/timed_cache.dart';

class StudentService {

  final StudentRepository _studentRepository = GetIt.I<StudentRepository>();
  late Stream<Set<Student>> studentStream;
  late Set<Student> students = {};
  late Set<String> groups = {};

  final _rfidCache = TimedCache<String, void>(const Duration(seconds: 25).inMilliseconds);
  final _rfidQueue = Queue();

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
    students.removeWhere((s) => s.studentId == student.studentId);
    students.add(student);
    return _studentRepository.updateStudent(student);
  }

  // TODO: improve setProfileImage in case student isn't created yet
  Future<void> createStudent(Map<String, dynamic> student, Uint8List profileImage) async {
    String studentId = await _studentRepository.createStudent(
        student['firstname'],
        student['middlename'] ?? '',
        student['lastname'],
        student['birthday'] ?? '',
        student['address'] ?? '',
        student['group'],
        profileImage,
        student['caregivers'],
        student['permissions']);

    return _studentRepository.setProfileImage(studentId, profileImage);
  }

  Future<void> deleteStudent(String studentId) {
    return _studentRepository.deleteStudent(studentId);
  }

  Future<void> createIncidence(String studentId, Incidence incidence) async {
    return _studentRepository.createIncidence(studentId, incidence);
  }

  Future<void> updateIncidence(String studentId, Incidence oldIncidence, Incidence newIncidence) async {
    return _studentRepository.updateIncidence(studentId, oldIncidence, newIncidence);
  }

  Future<void> deleteIncidence(String studentId, Incidence incidence) async {
    return _studentRepository.deleteIncidence(studentId, incidence);
  }

  List<Incidence> getIncidencesOfDays(List<Incidence> incidences, DateTime from, DateTime until) {
    List<Incidence> incidencesOfDays = [];
    for (var incidence in incidences) {
      DateTime date = DateTime.parse(incidence.dateTime);

      if (DateTime.parse(IsoDateUtils.getIsoDateFromIsoDateTime(date.toIso8601String())).isAfter(from.subtract(const Duration(days: 1))) && 
          DateTime.parse(IsoDateUtils.getIsoDateFromIsoDateTime(date.toIso8601String())).isBefore(until.add(const Duration(days: 1)))) {
        incidencesOfDays.add(incidence);
      }
    }
    return incidencesOfDays;
  }

  List<Incidence> getIncidencesOfToday(List<Incidence> incidences) {
    return getIncidencesOfDays(incidences, DateTime.now(), DateTime.now());
  }

  bool hasIncidences(String studentId) {
    List<Incidence> incidences = getStudent(studentId).incidences;
    for (var incidence in incidences) {
      if (IsoDateUtils.getIsoDateFromIsoDateTime(incidence.dateTime)
          == IsoDateUtils.getIsoDateFromIsoDateTime(DateTime.now().toIso8601String())) {
        return true;
      }
    }
    return false;
  }

  Future<void> registerRfidAttendance(String rfid, bool canUnregister) async {

    //print("Got RFID registration attempt: id: ${rfid}, canUnregister: ${canUnregister}");

    bool alreadyRegistered = _rfidCache.contains(rfid);
    if (alreadyRegistered) {
      //print("already registered");
      // if already registered, do nothing
      return;
    }

    _rfidCache.set(rfid, null);
    _rfidQueue.addFirst([rfid, DateTime.now()]);

    while (_rfidQueue.isNotEmpty) {
      var rfidRegistration = _rfidQueue.removeFirst();
      String? studentId;
      try {
        studentId = await _studentRepository.getStudentIdFromRfid(rfidRegistration[0]);
        //print("StudentId of RFID Tag: ${studentId}");
      } catch (err) {
        print("Error, enqueueing registration attempt..");
        print("Error: $err");
        // enqueue registration attempt
        _rfidQueue.addLast(rfidRegistration);
        return;
      }
      if (studentId == null) {
        // rfid not assigned to a student
        print("RFID not assigned to a student");
        return;
      }
      Student student = getStudent(studentId);
      Attendance? attendance = getAttendanceOfToday(student.attendances);
      // only register if not attendant or unregistering allowed
      if (attendance == null || attendance.leaving != null || canUnregister) {
        //print("Toggle attendance of student ${student.firstname} ${student.lastname}");
        toggleAttendance(studentId);
      }
    }


  }

  Future<void> toggleAttendance(String studentId, {DateTime? dateTime}) async {

    if (isAbsent(studentId)) {
      // if absent, do nothing
      return;
    }

    String now;
    if (dateTime != null) {
      now = dateTime.toIso8601String();
    } else {
      now = DateTime.now().toIso8601String();
    }
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
        if (coming.add(const Duration(minutes: 5)).isAfter(DateTime.now())) {
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

  List<Absence> getAbsencesOfToday(List<Absence> absences) {
    return getAbsencesOfDay(absences, DateTime.now());
  }

  List<Absence> getAbsencesOfDay(List<Absence> absences, DateTime date) {
    return getAbsencesInRange(absences, date, date);
  }

  // TODO: test if corner cases correct
  List<Absence> getAbsencesInRange(List<Absence> absences, DateTime first, [DateTime? last]) {
    List<Absence> absencesOfDay = [];
    for (var absence in absences) {
      DateTime from = DateTime.parse(absence.from);
      DateTime until = DateTime.parse(absence.until);

      if (last == null) {
        // get absences for every day starting at [first]
        if (until.add(const Duration(days: 1)).isAfter(first)) {
          absencesOfDay.add(absence);
        }
      } else {
        // get everything in range
        if ((first.isAfter(from) && first.isBefore(until.add(const Duration(days: 1))))
            || (last.isAfter(from) && last.isBefore(until.add(const Duration(days: 1))))
        ) {
          absencesOfDay.add(absence);
        }
      }
    }
    return absencesOfDay;
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
    var birthday = getStudent(studentId).birthday;
    if (birthday == "") {
      return false;
    }

    return IsoDateUtils.getIsoDateFromIsoDateTime(
        DateTime.now().toIso8601String()).substring(5) == birthday.substring(5);
  }

  Future<void> setProfileImage(String studentId, Uint8List image) async {
    return _studentRepository.setProfileImage(studentId, image);
  }

  bool isAbsent(String studentId) {
    return getAbsencesOfToday(getStudent(studentId).absences).isNotEmpty;
  }

  Future<void> createAbsence(String studentId, Absence absence) async {
    _studentRepository.createAbsence(studentId, absence);
  }

  Future<void> updateAbsence(String studentId, Absence oldAbsence, Absence newAbsence) async {
    _studentRepository.updateAbsence(studentId, oldAbsence, newAbsence);
  }

  Future<void> removeAbsence(String studentId, Absence absence) async {
    _studentRepository.deleteAbsence(studentId, absence);
  }

}