import 'dart:io';
import 'dart:typed_data';

import 'dart:convert';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/data/firebase_utils.dart';
import 'package:flutter/services.dart';
import 'package:kinga/domain/entity/absence.dart';
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

  late String currentInstitutionId;
  Set<Student>? currentStudents;

  final Directory _applicationDocumentsDirectory = GetIt.I<Directory>(instanceName: Keys.applicationDocumentsDirectory);

  final Map<String, Uint8List> _profileImagesCache = GetIt.I<Map<String, Uint8List>>(instanceName: Keys.profileImagesCache);

  FirebaseStudentRepository() {
    currentInstitutionId = GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: "").getValue();
  }

  cacheProfileImage(String studentId, Uint8List profileImage) {
    // cache profileImage
    _profileImagesCache[studentId] = profileImage;

    // store locally
    var file = File('${_applicationDocumentsDirectory.path}/profileImages/$studentId');
    file.create(recursive: true);
    file.writeAsBytes(profileImage);
  }

  Uint8List? getProfileImageFromCache(String studentId) {
    return _profileImagesCache[studentId];
  }

  clearProfileImageCache() {
    _profileImagesCache.clear();
    Directory('${_applicationDocumentsDirectory.path}/profileImages').delete(recursive: true);
  }

  @override
  Stream<Set<Student>> watchStudents() {
    return () async* { // anonymous async* function for returning as broadcastStream
      while (true) {
        var streamGroup = StreamGroup.merge(<Stream<dynamic>>[
          GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: ""),
          if (currentInstitutionId != "") db.collection('Institution').doc(currentInstitutionId).collection('Student').snapshots()
        ]);
        await for (var event in streamGroup) {
          if (event is String && event != currentInstitutionId) {
            if (currentInstitutionId != "") { // if user changed institution or logged out
              clearProfileImageCache();
            }
            currentInstitutionId = event;
            break; // break await for to create new streamGroup in next while(true) loop
          } else if (event is QuerySnapshot<Map<String, dynamic>>) {
            if (currentInstitutionId != "") {
              Set<Student> students = {};
              for (var doc in event.docs) {
                List tmp = FirebaseUtils.decryptStudent(doc.data()['value']);
                Student student = tmp[0];
                late Uint8List profileImage;
                String? profileImageHash = tmp[1];
                if (profileImageHash != null) {
                  // get profileImage from cache if exists
                  Uint8List? profileImageCache = (getProfileImageFromCache(student.studentId));
                  if (profileImageCache != null && base64.encode(profileImageCache).hashCode.toString() == profileImageHash) { // TODO: why is base64 faster than the alternatives below
                  //if (profileImageCache != null && profileImageCache.toString().hashCode.toString() == profileImageHash) {
                  //if (profileImageCache != null && sha1.convert(profileImageCache).toString() == profileImageHash) {
                    profileImage = profileImageCache;
                  } else {
                    Uint8List? profileImageDownload = await storage.ref().child('$currentInstitutionId/${student.studentId}').getData().catchError((e) => null);
                    if (profileImageDownload != null) {
                      profileImage = profileImageDownload;
                      cacheProfileImage(student.studentId, profileImageDownload); // store image in cache
                    } else {
                      profileImage = await randomImage(student.studentId);
                      setProfileImage(student.studentId, profileImage);
                    }
                  }
                } else {
                  profileImage = await randomImage(student.studentId);
                  setProfileImage(student.studentId, profileImage);
                }
                student.profileImage = profileImage;
                students.add(student);
              }
              if (event.docs.isEmpty) {
                // create test students
                createTestStudents();
              }
              yield students;
            } else {
              // TODO: error-handling
            }
          }
        }
      }
    }().asBroadcastStream();
  }

  @override
  Future<void> updateStudent(Student student) async {
    db.collection('Institution').doc(currentInstitutionId).collection('Student').doc(
        student.studentId).set(FirebaseUtils.studentToMap(student)).onError((error,
        stackTrace) {
      if (kDebugMode) {
        print(stackTrace);
      } // TODO
    });
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
      {},
    );
  }

  void createTestStudents() async {
    // TODO: create students instead from copying from debug
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance.collection('Institution').doc('debug')
        .collection('Student')
        .get();
    for (var doc in snapshot.docs) {
      Student student = mapToStudentLegacy(doc.data());
      // Map<String, dynamic> modernMap = studentToMap(student);
      student.profileImage = await randomImage(student.studentId);
      updateStudent(student);
    }
  }

  @override
  Future<void> createStudent(String firstname, String middlename, String lastname,
      String birthday, String street, String housenumber, String postcode,
      String city, Uint8List profileImage, List<Caregiver> caregivers) async {
    String address = '$street $housenumber, $postcode';
    String studentId = const Uuid().v1();

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
        [],
        {});

    db.collection('Institution').doc(currentInstitutionId).collection('Student')
        .doc(studentId)
        .set(FirebaseUtils.studentToMap(student))
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print(stackTrace);
      }
    });
    setProfileImage(studentId, profileImage);
  }

  @override
  Future<void> setProfileImage(String studentId, Uint8List image) async {
    // store in cache
    cacheProfileImage(studentId, image);
    // store in firebase storage
    FirebaseStorage.instance.ref().child('$currentInstitutionId/$studentId').putData(image);
    // update student
    StudentService studentService = GetIt.I<StudentService>();
    studentService.updateStudent(studentService.getStudent(studentId)..profileImage = image);
  }

  @override
  Future<void> createAbsence(String studentId, Absence absence) async {
    Student s = GetIt.I<StudentService>().getStudent(studentId);
    s.absences.add(absence);
    updateStudent(s);
  }

  @override
  Future<void> removeAbsence(String studentId, Absence absence) async {
    Student s = GetIt.I<StudentService>().getStudent(studentId);
    s.absences.remove(absence);
    updateStudent(s);
  }

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
