import 'package:kinga/domain/entity/Student.dart';

abstract class StudentRepository {
  List<Student> getAllStudents();
  Student getStudent(String studentId);
  Set<String> getAvailableGroups();

}