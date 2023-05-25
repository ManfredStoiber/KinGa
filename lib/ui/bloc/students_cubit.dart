import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/entity/attendance.dart';

part 'students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {

  final StudentService _studentService = GetIt.I<StudentService>();
  StreamSubscription<Set<Student>>? _streamSubscription;

  StudentsCubit() : super(StudentsInitial()) {
    emit(StudentsLoading());
    _streamSubscription = _studentService.watchStudents().listen((students) {
      if (students.isEmpty) {
        emit(StudentsEmpty());
      } else {
        emit(StudentsLoaded(students, null));
      }
    });
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    super.close();
  }

  bool hasIncidences(String studentId) {
    return _studentService.hasIncidences(studentId);
  }

  Future<void> toggleAttendance(String studentId) async {
    if (state is StudentsLoaded) {
      _studentService.toggleAttendance(studentId);
    }
  }

  Attendance? getAttendanceOfToday(List<Attendance> attendances) {
    return _studentService.getAttendanceOfToday(attendances);
  }

  bool isAttendant(String studentId) {
    return _studentService.isAttendant(studentId);
  }

  bool hasBirthday(String studentId) {
    return _studentService.hasBirthday(studentId);
  }

  Future<void> createStudent(Map<String, dynamic> student, Uint8List profileImage) async {
    return _studentService.createStudent(student, profileImage);
  }

  Future<void> updateStudent(Student student, Uint8List profileImage) async {
    await _studentService.updateStudent(student);
    return setProfileImage(student.studentId, profileImage);
  }

  Future<void> deleteStudent(String studentId) async {
    return _studentService.deleteStudent(studentId);
  }

  void setProfileImage(String studentId, Uint8List image) {
    _studentService.setProfileImage(studentId, image);
  }

  bool isAbsent(String studentId) {
    return _studentService.getAbsencesOfToday(_studentService.getStudent(studentId).absences).isNotEmpty;
  }

  Future<void> createAbsence(String studentId, Absence absence) async {
    _studentService.createAbsence(studentId, absence);
  }

  Future<void> updateAbsence(String studentId, Absence oldAbsence, Absence newAbsence) async {
    _studentService.updateAbsence(studentId, oldAbsence, newAbsence);
  }

}
