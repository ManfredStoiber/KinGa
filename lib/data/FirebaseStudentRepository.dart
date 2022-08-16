import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinga/domain/StudentRepository.dart';
import 'package:kinga/domain/entity/Student.dart';

class FirebaseStudentRepository implements StudentRepository {

  List<Student> students = [];
  Set<String> availableGroups = {};

  FirebaseStudentRepository() {
    db.collection('Institution').doc('f1x2NtOa90aJSlbOIX0fD4fOrns2').collection('Student').get().then((value) {
      for (var doc in value.docs) {
        students.add(Student(
          doc.data()['studentId'],
          doc.data()['firstname'],
          doc.data()['middlename'],
          doc.data()['lastname'],
          //doc.data()['birthday'],
          doc.data()['address'],
          doc.data()['city'],
          doc.data()['group'],
          //doc.data()['profileImage'],
          [],
          [],
          [],
          [],
          [],
        ));
        availableGroups.add(doc.data()['group']);
      }
    });
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  List<Student> getAllStudents() {
    return students;
  }

  @override
  Set<String> getAvailableGroups() {
    return availableGroups;
  }

  @override
  Student getStudent(String studentId) {
    return students.firstWhere((student) => student.studentId == studentId);
  }

}