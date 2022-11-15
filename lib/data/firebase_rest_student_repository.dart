import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:kinga/constants/keys.dart';
import 'package:kinga/data/firebase_utils.dart';
import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/util/crypto_utils.dart';
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
  Future<void> createStudent(String firstname, String middlename, String lastname, String birthday, String street, String housenumber, String postcode, String city, Uint8List profileImage, List<Caregiver> caregivers) {
    // TODO: implement createStudent
    throw UnimplementedError();
  }

  @override
  Future<void> setProfileImage(String studentId, Uint8List image) {
    // TODO: implement setProfileImage
    throw UnimplementedError();
  }

}