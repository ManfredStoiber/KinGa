import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:kinga/constants/keys.dart';
import 'package:kinga/data/firebase_utils.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FirebaseRestStudentRepository implements StudentRepository {

  final String firebaseFirestoreUrl = GetIt.I<String>(instanceName: Keys.firebaseFirestoreUrl);

  @override
  Future<void> updateStudent(Student student) {
    // TODO: implement updateStudent
    throw UnimplementedError();
  }

  @override
  Stream<Set<Student>> watchStudents() async* {

    while (true) {

      String institutionId = GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: "").getValue();
      var response = await http.get(Uri.https(firebaseFirestoreUrl, "v1/projects/kinga-a6510/databases/(default)/documents/Institution/$institutionId/Student"));

      if (response.statusCode == 200) {
        Set<Student> students = {};
        var result = json.decode(response.body);
        for (var doc in result['documents']) {
          List tmp = FirebaseUtils.decryptStudent(doc['fields']['value']['stringValue']);
          // TODO: fetch profileImage
          Student s = tmp[0];
          students.add(s);
        }
        yield students;
      }

      await Future.delayed(Duration(seconds: 60));
    }
  }

  @override
  Future<String> createStudent(String firstname, String middlename, String lastname, String birthday, String address, String group, Uint8List profileImage, List<Caregiver> caregivers, Set<String> permissions) {
    // TODO: implement createStudent
    throw UnimplementedError();
  }

  @override
  Future<void> deleteStudent(String studentId) {
    // TODO: implement createStudent
    throw UnimplementedError();
  }

  @override
  Future<void> setProfileImage(String studentId, Uint8List image) {
    // TODO: implement setProfileImage
    throw UnimplementedError();
  }

  @override
  Future<void> createAbsence(String studentId, Absence absence) {
    // TODO: implement createAbsence
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAbsence(String studentId, Absence absence) {
    // TODO: implement removeAbsence
    throw UnimplementedError();
  }

  @override
  Future<void> createIncidence(String studentId, Incidence incidence) {
    // TODO: implement createIncidence
    throw UnimplementedError();
  }

  @override
  Future<void> deleteIncidence(String studentId, Incidence incidence) {
    // TODO: implement deleteIncidence
    throw UnimplementedError();
  }

  @override
  Future<void> updateAbsence(String studentId, Absence oldAbsence, Absence newAbsence) {
    // TODO: implement updateAbsence
    throw UnimplementedError();
  }

  @override
  Future<void> updateIncidence(String studentId, Incidence oldIncidence, Incidence newIncidence) {
    // TODO: implement updateIncidence
    throw UnimplementedError();
  }

}