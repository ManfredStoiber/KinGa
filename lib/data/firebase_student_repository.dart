import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinga/domain/entity/absence.dart';
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
        students.add(mapToStudent(doc.data()));
      }
      yield students;
    }
  }

  @override
  Future<void> updateStudent(Student student) async {
    db.collection('Institution').doc('debug').collection('Student').doc(student.studentId).set(studentToMap(student)).onError((error, stackTrace) {
      print(stackTrace);
    });
  }

  @override
  Future<void> createAbsence(String studentId, Absence absence) async {
    db.collection('Institution').doc('debug').collection('Student').doc(studentId).get().then((student)
    {
      if (student.data() != null) {
        Student s = mapToStudent(student.data()!);
        s.absences.add(absence);
        updateStudent(s);
      }
    });
  }
}

Map<String, dynamic> studentToMap(Student student) {
  // convert student to map
  Map<String, dynamic> map = {
    'studentId': student.studentId,
    'firstname': student.firstname,
    'middlename': student.middlename,
    'lastname': student.lastname,
    'birthday': student.birthday,
    'address': student.address,
    'city': student.city,
    'group': student.group,
  };
  List<Map<String, dynamic>> absences = [];
  for (final Absence absence in student.absences) {
    absences.add({
      'from': absence.from,
      'until': absence.until,
      'sickness': absence.sickness
    });
  }
  map['absences'] = absences;

  List<Map<String, dynamic>> attendances = [];
  for (final Attendance attendance in student.attendances) {
    attendances.add({
      'date': attendance.date,
      'coming': attendance.coming,
      'leaving': attendance.leaving
    });
  }
  map['attendances'] = attendances;

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
  map['caregivers'] = caregivers;
  
  return map;
}

Student mapToStudent(Map<String, dynamic> map) {
  // absences
  List<Absence> absences = [];
  for (var absence in map['absences'] ?? {}) {
    absences.add(Absence(
      absence['from'],
      absence['until'],
      absence['sickness'],
    ));
  }
  // attendances
  Set<Attendance> attendances = {};
  for (var attendance in map['attendances'] ?? {}) {
    attendances.add(Attendance(
      attendance['date'],
      attendance['coming'],
      leaving: attendance['leaving'],
    ));
  }
  // caregivers
  Set<Caregiver> caregivers = {};
  for (var caregiver in map['caregivers'] ?? {}) {
    caregivers.add(Caregiver(
        caregiver['firstname'],
        caregiver['lastname'],
        caregiver['label'],
        Map<String, String>.from(caregiver['phoneNumbers']),
        caregiver['email']
    ));
  }

  return Student(
    map['studentId'],
    map['firstname'],
    map['middlename'],
    map['lastname'],
    map['birthday'],
    map['address'],
    map['city'],
    map['group'],
    //map['profileImage'],
    caregivers.toList(),
    attendances.toList(),
    absences,
    [],
    [],
    [],
    [],
    [],
  );
}