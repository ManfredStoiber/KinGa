import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/entity/student.dart';

abstract class StudentRepository {
  Stream<Set<Student>> watchStudents();
  Future<void> updateStudent(Student student);
  Future<void> createAbsence(String studentId, Absence absence);
}