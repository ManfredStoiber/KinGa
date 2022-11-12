part of '../bloc/students_cubit.dart';


abstract class StudentsState {
  const StudentsState();
}

class StudentsInitial extends StudentsState {}
class StudentsLoading extends StudentsState {}
class StudentsLoaded extends StudentsState {
  final Set<Student> students;
  late final Set<String> groups;
  final Student? selected;
  StudentsLoaded(this.students, this.selected) {
    Set<String> tmp = {};
    for (var student in students) {
      tmp.add(student.group);
    }
    groups = tmp;
  }

  Student getStudent(String studentId) {
    return students.firstWhere((student) => student.studentId == studentId);
  }
}
class StudentsError extends StudentsState {}
