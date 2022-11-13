import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/entity/attendance.dart';

part 'students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {

  final StudentService _studentService;
  StreamSubscription<Set<Student>>? _streamSubscription;

  StudentsCubit(this._studentService) : super(StudentsInitial()) {
    emit(StudentsLoading());
    _streamSubscription = _studentService.watchStudents().listen((students) {
      emit(StudentsLoaded(students, null));
    });
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    super.close();
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

  void createStudent(Map<String, dynamic> student, Uint8List profileImage) {
    _studentService.createStudent(student, profileImage);
  }

  void setProfileImage(String studentId, Uint8List image) {
    _studentService.setProfileImage(studentId, image);
  }


}
