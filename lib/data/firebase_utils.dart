import 'dart:convert';
import 'dart:typed_data';

import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/util/crypto_utils.dart';

class FirebaseUtils {

  static List decryptStudent(String decrypted) {

    Map map = json.decode(CryptoUtils.decrypt(decrypted));

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
    return [Student(
      map['studentId'],
      map['firstname'],
      map['middlename'],
      map['lastname'],
      map['birthday'],
      map['address'],
      map['city'],
      map['group'],
      Uint8List(0),
      //map['profileImage'],
      caregivers.toList(),
      attendances.toList(),
      [],
      [],
      [],
      [],
      [],
    ), map['profileImage']];
  }
}