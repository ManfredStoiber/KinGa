import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/student.dart';

class FirebaseStudentRepository implements StudentRepository {

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Stream<Set<Student>> watchStudents() async* {
    await for (final value in db.collection('Institution').doc('debug').collection('Student').snapshots()) {
      Set<Student> students = {};
      for (var doc in value.docs) {
        // attendances
        Set<Attendance> attendances = {};
        for (var attendance in doc.data()['attendances']) {
          attendances.add(Attendance(
            attendance['date'],
            attendance['coming'],
            leaving: attendance['leaving'],
          ));
        }
        // caregivers
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
          caregivers.toList(),
          attendances.toList(),
          [],
          [],
          [],
          [],
          [],
        ));
      }
      yield students;
    }
  }

  @override
  Future<void> updateStudent(Student student) async {
    // convert student to map
    Map<String, dynamic> s = {
      'studentId': student.studentId,
      'firstname': student.firstname,
      'middlename': student.middlename,
      'lastname': student.lastname,
      'birthday': student.birthday,
      'address': student.address,
      'city': student.city,
      'group': student.group,
    };
    List<Map<String, dynamic>> attendances = [];
    for (final Attendance attendance in student.attendances) {
      attendances.add({
        'date': attendance.date,
        'coming': attendance.coming,
        'leaving': attendance.leaving
      });
    }
    s['attendances'] = attendances;

    List<Map<String, dynamic>> caregivers = [];
    for (final Caregiver caregiver in student.caregivers) {
      caregivers.add({
        'firstname': caregiver.firstname,
        'lastname': caregiver.lastname,
        'label': caregiver.label,
        'phoneNumbers': caregiver.phoneNumbers,
        'email': caregiver.email
      });
    }
    s['caregivers'] = caregivers;

    db.collection('Institution').doc('debug').collection('Student').doc(student.studentId).set(s).onError((error, stackTrace) {
      print(stackTrace);
    });
  }
}