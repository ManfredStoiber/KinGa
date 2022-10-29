import 'dart:typed_data';

import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/entity/student.dart';

import 'entity/caregiver.dart';

abstract class StudentRepository {
  Stream<Set<Student>> watchStudents();
  Future<void> updateStudent(Student student);
  Future<void> createStudent(String firstname, String middlename, String lastname,
      String birthday, String street, String housenumber, String postcode,
      String city, Uint8List profileImage, List<Caregiver> caregivers);
  Future<void> setProfileImage(String studentId, Uint8List image);
  Future<void> createAbsence(String studentId, Absence absence);
  Future<void> deleteAbsence(String studentId, Absence absence);
  Future<void> createIncidence(String studentId, Incidence incidence);
  Future<void> deleteIncidence(String studentId, Incidence incidence);
}