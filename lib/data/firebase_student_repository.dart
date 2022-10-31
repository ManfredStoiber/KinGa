import 'dart:typed_data';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:encrypt/encrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:flutter/services.dart';
import 'package:kinga/domain/entity/attendance.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/util/crypto_utils.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FirebaseStudentRepository implements StudentRepository {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  StreamingSharedPreferences prefs = GetIt.instance.get<StreamingSharedPreferences>();

  late String institutionId;

  Map<String, Uint8List> studentProfileImages = {};

  FirebaseStudentRepository() {
    //GetIt.instance.get<StreamingSharedPreferences>().setString(Strings.institutionId, 'debug');
    // TODO: maybe listen to instituationId?
    institutionId = prefs.getString(Keys.institutionId, defaultValue: "").getValue();
  }

  @override
  Stream<Set<Student>> watchStudents() async* {
    if (institutionId != "") {
      await for (final value in db.collection('Institution')
          .doc(prefs.getString(Keys.institutionId, defaultValue: "").getValue())
          .collection('Student')
          .snapshots()) {
        Set<Student> students = {};
        for (var doc in value.docs) {
          Student student = await mapToStudent(doc.data());
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
    String institutionId = prefs.getString(Keys.institutionId, defaultValue: "")
        .getValue();
    db.collection('Institution').doc(institutionId).collection('Student').doc(
        student.studentId).set(studentToMap(student)).onError((error,
        stackTrace) {
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
    map['profileImage'] = student.profileImage.hashCode.toString();

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

    // return student
    return Student(
      map['studentId'],
      map['firstname'],
      map['middlename'],
      map['lastname'],
      map['birthday'],
      map['address'],
      map['city'],
      map['group'],
      Uint8List.fromList([]),
      caregivers.toList(),
      attendances.toList(),
      [],
      [],
      [],
      [],
      [],
    );
  }

  Future<Student> mapToStudent(Map<String, dynamic> map) async {
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

    late Uint8List profileImage;
    String? profileImageHash = map['profileImage'];
    if (profileImageHash != null) {
      // get profileImage from cache if exists
      Uint8List? profileImageCache = (studentProfileImages[map['studentId']]);
      if (profileImageCache != null) {
        profileImage = profileImageCache;
      } else {
        Uint8List? profileImageDownload = await storage.ref().child('$institutionId/${map['studentId']}').getData();
        if (profileImageDownload != null) {
          profileImage = profileImageDownload;
          studentProfileImages[map['studentId']] = profileImageDownload; // store image in cache
        } else {
          profileImage = Uint8List(0); // TODO: load placeholder image
        }
      }
    } else {
      profileImage = Uint8List(0); // TODO: load placeholder image
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
      profileImage,
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
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance.collection('Institution').doc(institutionId)
        .collection('Student')
        .get();
    for (var doc in snapshot.docs) {
      Student student = mapToStudentLegacy(doc.data());
      Map<String, dynamic> modernMap = studentToMap(student);
      updateStudent(student);
    }
  }

  @override
  Future<void> createStudent(String firstname, String middlename, String lastname,
      String birthday, String street, String housenumber, String postcode,
      String city, Uint8List profileImage, List<Caregiver> caregivers) async {
    String address = '$street $housenumber, $postcode';
    String studentId = Uuid().v1();

    if (profileImage.isEmpty) profileImage = await randomImage(studentId);

    Student student = Student(
        studentId,
        firstname,
        middlename,
        lastname,
        birthday,
        address,
        city,
        '',
        profileImage,
        caregivers,
        [],
        [],
        [],
        [],
        [],
        []);

    db.collection('Institution').doc(institutionId).collection('Student')
        .doc(studentId)
        .set(studentToMap(student))
        .onError((error, stackTrace) {
      print(stackTrace);
    });
    setProfileImage(studentId, profileImage);
  }

  @override
  Future<void> setProfileImage(String studentId, Uint8List image) async {
    // store in cache
    studentProfileImages[studentId] = image;
    // store in firebase storage
    FirebaseStorage.instance.ref().child('$institutionId/$studentId').putData(image);
    // update student
    StudentService studentService = GetIt.I<StudentService>();
    studentService.updateStudent(studentService.getStudent(studentId)..profileImage = image);
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

Future<Uint8List> randomImage(String studentId) async {
  int hashValue = studentId.hashCode.abs();
  String image = 'assets/images/';

  switch ((hashValue % 35).toInt()) {
    case 0:
      image += 'bear.png';
      break;
    case 1:
      image += 'beaver.png';
      break;
    case 2:
      image += 'bees.png';
      break;
    case 3:
      image += 'boar.png';
      break;
    case 4:
      image += 'bull.png';
      break;
    case 5:
      image += 'camel.png';
      break;
    case 6:
      image += 'crocodile.png';
      break;
    case 7:
      image += 'deer.png';
      break;
    case 8:
      image += 'duck.png';
      break;
    case 9:
      image += 'eagle.png';
      break;
    case 10:
      image += 'elephant.png';
      break;
    case 11:
      image += 'fox.png';
      break;
    case 12:
      image += 'frog.png';
      break;
    case 13:
      image += 'giraffe.png';
      break;
    case 14:
      image += 'goat.png';
      break;
    case 15:
      image += 'gorilla.png';
      break;
    case 16:
      image += 'hedgehog.png';
      break;
    case 17:
      image += 'hippo.png';
      break;
    case 18:
      image += 'horse.png';
      break;
    case 19:
      image += 'koala.png';
      break;
    case 20:
      image += 'lion.png';
      break;
    case 21:
      image += 'owl.png';
      break;
    case 22:
      image += 'panda.png';
      break;
    case 23:
      image += 'parrot.png';
      break;
    case 24:
      image += 'polar_bear.png';
      break;
    case 25:
      image += 'rabbit.png';
      break;
    case 26:
      image += 'racoon.png';
      break;
    case 27:
      image += 'rhinoceros.png';
      break;
    case 28:
      image += 'sheep.png';
      break;
    case 29:
      image += 'sloth.png';
      break;
    case 30:
      image += 'snake.png';
      break;
    case 31:
      image += 'squirrel.png';
      break;
    case 32:
      image += 'tiger.png';
      break;
    case 33:
      image += 'walrus.png';
      break;
    case 34:
      image += 'wolf.png';
      break;
    case 35:
      image += 'zebra.png';
      break;
  }

  ByteData bytes = await rootBundle.load(image);
  Uint8List list = bytes.buffer.asUint8List();
  return list;
}
