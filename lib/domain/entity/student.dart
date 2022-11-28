import 'dart:typed_data';

import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/features/observations/domain/entity/observation.dart';

import 'attendance.dart';
import 'person.dart';

class Student extends Person implements Comparable<Student> {

  String studentId;
  String middlename;
  String birthday; // ISO-String
  String address = "";
  String group = "";
  List<Incidence> incidences = [];
  List<Caregiver> caregivers;
  List<Person> pickups;
  List<Attendance> attendances;
  Uint8List? profileImage;
  List<Absence> absences;
  List<String> allergies;
  List<String> diseases;
  List<String> medicines;
  List<String> healthNotes;
  Set<String> permissions;
  List<Observation> observations;



  Student(
      this.studentId,
      super.firstname,
      this.middlename,
      super.lastname,
      this.birthday,
      this.address,
      this.group,
      [ this.profileImage,
        this.caregivers = const [],
        this.attendances = const [],
        this.pickups = const [],
        this.absences = const [],
        this.allergies = const [],
        this.diseases = const [],
        this.medicines = const [],
        this.healthNotes = const [],
        this.incidences = const [],
        this.permissions = const {},
        this.observations = const []]
  );

  @override
  int compareTo(Student other) {
    // TODO: compare all properties
    return "$firstname $lastname".compareTo("${other.firstname} ${other.lastname}");
  }

}


