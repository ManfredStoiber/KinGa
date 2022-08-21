import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/student.dart';

class FirebaseStudentRepository implements StudentRepository {

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<Set<Student>> getAllStudents() {
    return Future (() async {
      Set<Student> students = {};
      QuerySnapshot<Map<String, dynamic>> value = await db.collection('Institution').doc('debug')
          .collection('Student').get();
      for (var doc in value.docs) {
        Set<Caregiver> caregivers = {};
        for (var caregiver in doc.data()['caregivers']) {
          caregivers.add(Caregiver(
            caregiver['firstname'],
            caregiver['lastname'],
            caregiver['label'],
            Map<String, String>.from(caregiver['phoneNumbers']),
            caregiver['email']
          ));
        }
        students.add(Student(
          doc.data()['studentId'],
          doc.data()['firstname'],
          doc.data()['middlename'],
          doc.data()['lastname'],
          doc.data()['birthday'],
          doc.data()['address'],
          doc.data()['city'],
          doc.data()['group'],
          //doc.data()['profileImage'],
          [],
          [],
          [],
          [],
          [],
          [],
        ));
      }
      return students;
    },);
  }

}