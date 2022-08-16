import 'package:kinga/domain/StudentRepository.dart';
import 'package:kinga/domain/entity/Student.dart';

class StudentService {

  StudentRepository studentRepository;

  StudentService(this.studentRepository);

  List<Student> getAllStudents() {
    return studentRepository.getAllStudents();
  }

  Student getStudent(String studentId) {
    return studentRepository.getStudent(studentId);
  }

  Set<String> getAvailableGroups() {
    return studentRepository.getAvailableGroups();
  }
}