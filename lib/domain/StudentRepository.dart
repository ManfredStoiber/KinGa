import 'package:kinga/domain/entity/Student.dart';

abstract class StudentRepository {
  Future<Set<Student>> getAllStudents();
}