import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinga/domain/StudentRepository.dart';
import 'package:kinga/domain/entity/Student.dart';

class FirebaseStudentRepository implements StudentRepository {

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Future<Set<Student>> getAllStudents() {
    return Future (() async {
      Set<Student> students = {};
      QuerySnapshot<Map<String, dynamic>> value = await db.collection('Institution').doc('f1x2NtOa90aJSlbOIX0fD4fOrns2')
          .collection('Student').get();
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
      }
      return students;
    },);
  }

}