import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/util/crypto_utils.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FirebaseStudentRepository implements StudentRepository {

  FirebaseFirestore db = FirebaseFirestore.instance;
  late StreamingSharedPreferences prefs;

  FirebaseStudentRepository() {
    prefs = GetIt.instance.get<StreamingSharedPreferences>();
    //GetIt.instance.get<StreamingSharedPreferences>().setString(Strings.institutionId, 'debug');
  }

  @override
  Stream<Set<Student>> watchStudents() async* {
    // TODO: maybe listen to instituationId?
    String institutionId = prefs.getString(Keys.institutionId, defaultValue: "").getValue();
    if (institutionId != "") {
      await for (final value in db.collection('Institution').doc(prefs.getString(Keys.institutionId, defaultValue: "").getValue()).collection('Student').snapshots()) {
        Set<Student> students = {};
        for (var doc in value.docs) {
          Student student = mapToStudent(doc.data());
          students.add(student);
        }
        if (value.docs.length == 0) {
          // create test students
          createTestStudents();
        }
        yield students;
      }
    } else {
      // TODO: error-handling
    }
  }

  @override
  Future<void> updateStudent(Student student) async {
    // TODO: maybe listen to instituationId? And error handling like above
    String institutionId = prefs.getString(Keys.institutionId, defaultValue: "").getValue();
    db.collection('Institution').doc(institutionId).collection('Student').doc(student.studentId).set(studentToMap(student)).onError((error, stackTrace) {
      print(stackTrace);
    });
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

    return {'value': CryptoUtils.encrypt(json.encode(map))};
  }

  Student mapToStudentLegacy(Map<String, dynamic> map) {

    // absences
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

    // decrypt and return student
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
      [],
      [],
      [],
      [],
      [],
    );
  }

  Student mapToStudent(Map<String, dynamic> map) {

    map = json.decode(CryptoUtils.decrypt(map['value']));

    // absences
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

    // decrypt and return student
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
      [],
      [],
      [],
      [],
      [],
    );
  }

  void createTestStudents() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('Institution').doc('debug').collection('Student').get();
    for (var doc in snapshot.docs) {
      Student student = mapToStudentLegacy(doc.data());
      Map<String, dynamic> modernMap = studentToMap(student);
      updateStudent(student);
    }
  }

}