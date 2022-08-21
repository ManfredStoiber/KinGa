import 'package:kinga/domain/entity/student.dart';

abstract class StudentRepository {
  Future<Set<Student>> getAllStudents();
}