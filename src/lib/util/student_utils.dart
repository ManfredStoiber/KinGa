import 'dart:convert';
import 'dart:typed_data';

import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/util/crypto_utils.dart';

class StudentUtils {

  static Map<String, dynamic> decryptStudent(String studentId, String encrypted) {

    Map map = json.decode(CryptoUtils.decrypt(encrypted));

    // absences
    List<Absence> absences = [];
    for (var absence in map['absences'] ?? {}) {
      absences.add(Absence(
        absence['from'],
        absence['until'],
        absence['reason'] ?? "",
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

    // incidences
    List<Incidence> incidences = [];
    for (var incidence in map['incidences'] ?? {}) {
      incidences.add(Incidence(
        incidence['dateTime'],
        incidence['description'],
        incidence['category'] ?? Strings.other
      ));
    }

    // decrypt and return student
    return {'student': Student(
      studentId,
      map['firstname'],
      map['middlename'],
      map['lastname'],
      map['birthday'],
      map['address'],
      map['group'],
      Uint8List(0),
      caregivers.toList(),
      attendances.toList(),
      absences,
      [],
      [],
      [],
      [],
      incidences,
      Set<String>.from(map['permissions'] ?? [])
    ),
    'profileImage': map['profileImage'],
    'observationsTimestamp': map['observationsTimestamp']};
  }

  static Map<String, dynamic> studentToMap(Student student) {
    // convert student to map
    Map<String, dynamic> map = {
      'firstname': student.firstname,
      'middlename': student.middlename,
      'lastname': student.lastname,
      'birthday': student.birthday,
      'address': student.address,
      'group': student.group,
    };

    List<Map<String, dynamic>> absences = [];
    for (final Absence absence in student.absences) {
      absences.add({
        'from': absence.from,
        'until': absence.until,
        'reason': absence.reason
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
    if (student.profileImage != null) {
      map['profileImage'] = base64.encode(student.profileImage!).hashCode.toString();
    }
    //map['profileImage'] = student.profileImage.toString().hashCode.toString();
    //map['profileImage'] = sha1.convert(student.profileImage).toString();

    List<Map<String, dynamic>> incidences = [];
    for (final Incidence incidence in student.incidences) {
      incidences.add({
        'dateTime': incidence.dateTime,
        'description': incidence.description,
        'category': incidence.category,
      });
    }
    map['incidences'] = incidences;

    // permissions
    map['permissions'] = student.permissions.toList();

    return {'value': CryptoUtils.encrypt(json.encode(map))};
  }

}