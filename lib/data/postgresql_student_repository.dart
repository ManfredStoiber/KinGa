import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:image/image.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/data/mqtt_client_manager.dart';
import 'package:kinga/data/firebase_utils.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/student_service.dart';
import 'package:kinga/generated/backend.pbgrpc.dart' as gen;
import 'package:kinga/util/crypto_utils.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PostgreSQLStudentRepository implements StudentRepository {
  late gen.BackendClient clientStub;
  late String currentInstitutionId;

  late MqttClientManager mqttClientManager;
  final String subTopic = 'watch_students';

  Set<Student>? currentStudents;

  final Directory _applicationDocumentsDirectory = GetIt.I<Directory>(instanceName: Keys.applicationDocumentsDirectory);

  final Map<String, Uint8List> _profileImagesCache = GetIt.I<Map<String, Uint8List>>(instanceName: Keys.profileImagesCache);
  //final Map<String, DateTime> _observationsTimestamps = {};

  PostgreSQLStudentRepository() {
    currentInstitutionId = GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: "").getValue();

    final channel = ClientChannel(
      Keys.serverIpAddress,
      port: Keys.port,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    clientStub = gen.BackendClient(channel);

    mqttClientManager = MqttClientManager();
    setupMqttClient();
    setupUpdatesListener();
  }

  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    mqttClientManager.subscribe(subTopic);
  }

  void setupUpdatesListener() {
    mqttClientManager
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
    });
  }

  cacheProfileImage(String studentId, Uint8List profileImage) {
    // cache profileImage
    _profileImagesCache[studentId] = profileImage;

    // store locally
    var file = File('${_applicationDocumentsDirectory.path}${Platform.pathSeparator}profileImages${Platform.pathSeparator}$studentId');
    file.create(recursive: true);
    file.writeAsBytes(profileImage);
  }

  Uint8List? getProfileImageFromCache(String studentId) {
    return _profileImagesCache[studentId];
  }

  clearProfileImageCache() {
    _profileImagesCache.clear();
    Directory('${_applicationDocumentsDirectory.path}${Platform.pathSeparator}profileImages').delete(recursive: true);
  }

  @override
  Future<void> createAbsence(String studentId, Absence absence) async {
    Student s = GetIt.I<StudentService>().getStudent(studentId);
    s.absences.add(absence);
    updateStudent(s);
  }

  @override
  Future<void> createIncidence(String studentId, Incidence incidence) {
    Student s = GetIt.I<StudentService>().getStudent(studentId);
    s.incidences.add(incidence);
    return updateStudent(s);
  }

  @override
  Future<String> createStudent(String firstname, String middlename, String lastname, String birthday, String address, String group, Uint8List profileImage, List<Caregiver> caregivers, Set<String> permissions) async {
    String studentId = const Uuid().v1();

    if (profileImage.isEmpty) profileImage = await randomImage(studentId);

    Student student = Student(
        studentId,
        firstname,
        middlename,
        lastname,
        birthday,
        address,
        group,
        profileImage,
        caregivers,
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        permissions);

    try {
      await clientStub.createStudent(gen.Student()
        ..studentId = student.studentId
        ..value = FirebaseUtils.studentToMap(student)['value']
        ..institutionId = currentInstitutionId
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return studentId;
  }

  @override
  Future<void> deleteAbsence(String studentId, Absence absence) async {
    Student s = GetIt.I<StudentService>().getStudent(studentId);
    s.absences.remove(absence);
    updateStudent(s);
  }

  @override
  Future<void> deleteIncidence(String studentId, Incidence incidence) {
    Student s = GetIt.I<StudentService>().getStudent(studentId);
    s.incidences.remove(incidence);
    return updateStudent(s);
  }

  @override
  Future<void> deleteStudent(String studentId) async {
    try {
      await clientStub.deleteStudent(gen.Id()..requestId=studentId).then((_) {
        clientStub.deleteProfileImage(gen.Id()..requestId=studentId);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Future<String?> getStudentIdFromRfid(String rfid) {
    // TODO: implement getStudentIdFromRfid
    throw UnimplementedError();
  }

  @override
  Future<void> setProfileImage(String studentId, Uint8List image) async {
    if (image.isEmpty) {
      image = await randomImage(studentId);
    }

    // store in cache
    cacheProfileImage(studentId, image);
    // encrypt and store in firebase storage
    var encrypted = CryptoUtils.encrypt(base64.encode(image));
    try {
      await clientStub.createProfileImage(gen.ProfileImage()..studentId=studentId..data=encrypted);
    } on GrpcError catch (e) {
      //TODO
    }

    // update student
    StudentService studentService = GetIt.I<StudentService>();
    return studentService.updateStudent(studentService.getStudent(studentId)..profileImage = image);
  }

  @override
  Future<void> updateAbsence(String studentId, Absence oldAbsence, Absence newAbsence) async {
    Student s = GetIt.I<StudentService>().getStudent(studentId);
    s.absences.remove(oldAbsence);
    s.absences.add(newAbsence);
    updateStudent(s);
  }

  @override
  Future<void> updateIncidence(String studentId, Incidence oldIncidence, Incidence newIncidence) {
    Student s = GetIt.I<StudentService>().getStudent(studentId);
    s.incidences.remove(oldIncidence);
    s.incidences.add(newIncidence);
    return updateStudent(s);
  }

  @override
  Future<void> updateStudent(Student student) async {
    //TODO: fix try catch because 'OK' is a grpc error
    //try {
      await clientStub.updateStudent(gen.Student()
        ..studentId = student.studentId
        ..value = FirebaseUtils.studentToMap(student)['value']
        ..institutionId = currentInstitutionId
      );
    /*} catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }*/
  }

  @override
  Stream<Set<Student>> watchStudents() {
  return () async* { // anonymous async* function for returning as broadcastStream
    while (true) {
      var initializationStreamController = StreamController<String>();
      // merges all events into one stream to listen to all in parallel
      var streamGroup = StreamGroup.merge(<Stream<dynamic>>[
        initializationStreamController.stream,
        GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: ""),
        mqttClientManager.getMessagesStream()!
      ]);

      // to initialize students before any mqtt event is triggered
      initializationStreamController.add(Keys.initializationStreamController);
      await for (var event in streamGroup) {
        if (event is String && event != Keys.initializationStreamController && event != currentInstitutionId) {
          if (currentInstitutionId != "") { // if user changed institution or logged out
            clearProfileImageCache();
          }
          currentInstitutionId = event;
          break; // break await for to create new streamGroup in next while(true) loop
        } else if (event is String && event == Keys.initializationStreamController) {
          var students = await retrieveStudentsForInstitution();
          if (students != null) {
            yield students;
          }
        } else if (event is List<MqttReceivedMessage<MqttMessage>>) {
          final recMess = event[0].payload as MqttPublishMessage;
          final pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          print('MQTTClient::Message received on topic: <${event[0].topic}> is $pt\n');

          var students = await retrieveStudentsForInstitution();
          if (students != null) {
            yield students;
          }
        }
      }
    }
  }().asBroadcastStream();
  }

  Future<Set<Student>?> retrieveStudentsForInstitution() async {
    if (currentInstitutionId != '') {
      Set<Student> students = {};

      List<gen.Student> tmp = <gen.Student>[];
      //TODO: fix try catch because 'OK' is a grpc error
      //try {
        var receivedStudents = clientStub.retrieveInstitutionStudents(gen.Id()..requestId=currentInstitutionId);
        await for (var student in receivedStudents) {
          if (student.studentId != '') tmp.add(student);
        }

        for (var response in tmp) {
          Map<String, dynamic> decrypted = FirebaseUtils.decryptStudent(response.value);
          Student student = decrypted['student'];
          late Uint8List profileImage;
          String? profileImageHash = decrypted['profileImage'];
          //DateTime observationsTimestamp = DateTime.now();
          if (decrypted['observationsTimestamp'] != null) {
            //observationsTimestamp = DateTime.parse(decrypted['observationsTimestamp']);
          }

          // load profileImage
          if (profileImageHash != null) {
            // get profileImage from cache if exists
            Uint8List? profileImageCache = (getProfileImageFromCache(student.studentId));
            if (profileImageCache != null && base64.encode(profileImageCache).hashCode.toString() == profileImageHash) { // TODO: why is base64 faster than the alternatives below
              //if (profileImageCache != null && profileImageCache.toString().hashCode.toString() == profileImageHash) {
              //if (profileImageCache != null && sha1.convert(profileImageCache).toString() == profileImageHash) {
              profileImage = profileImageCache;
            } else {
              String? profileImageDownload;
              clientStub.retrieveProfileImage(gen.Id()..requestId=student.studentId).then((response) {
                if (response.data.isNotEmpty) profileImageDownload = response.data;
              });
              if (profileImageDownload != null) {
                // decrypt profileImage
                try {
                  profileImage =
                      Uint8List.fromList(base64.decode(CryptoUtils.decrypt(profileImageDownload!)));
                } catch (e) {
                  // if decryption failed, image is stored unencrypted // TODO: remove when everything is encrypted
                  profileImage = Uint8List.fromList(base64.decode(profileImageDownload!));
                }
                cacheProfileImage(student.studentId, profileImage); // store image in cache
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

          /* TODO
              // load observations if out of date
          if (_observationsTimestamps[student.studentId]?.isBefore(observationsTimestamp) ?? true) {
            var observations = await GetIt.I<ObservationService>().getObservations(student.studentId);
            student.observations = observations;
          }*/

          students.add(student);
        }
      /*} on GrpcError catch (e) {
        return null; //TODO: error-handling
      }*/
      if (tmp.isEmpty) {
          // create test students
          createTestStudents();
      }
      return students;
    } else {
      return null; // TODO: error-handling
    }
  }

  void createTestStudents() async {
    createStudent('Elias', '', 'Schulz', '2017-11-25', 'Musterstraße 1 12345 Musterhausen', 'Mondschein', Uint8List(0),
        [Caregiver('Lisa', 'Schulz', 'Mama', {'Handy Arbeit': '0160654321', 'Handy Privat': '0160123456'}, 'Lisa.Schulz@beispiel.de'),
         Caregiver('Lukas', 'Schulz', 'Papa', {'Handy Arbeit': '0175654321', 'Handy Privat': '0175123456'}, 'Lukas.Schulz@beispiel.de')],
        {'Pinnwand', 'Zeitung', 'Website'}
    );
    createStudent('Emilia', '', 'Schmidt', '2018-10-29', 'Musterstraße 1 12345 Musterhausen', 'Sonnenschein', Uint8List(0),
        [Caregiver('Anna', 'Schmidt', 'Mama', {'Handy Arbeit': '0160654321', 'Handy Privat': '0160123456'}, 'Anna.Schmidt@beispiel.de'),
          Caregiver('Günther', 'Schmidt', 'Papa', {'Handy Arbeit': '0175654321', 'Handy Privat': '0175123456'}, 'Guenther.Schmidt@beispiel.de')],
        {'Pinnwand', 'Zeitung', 'Website'}
    );
    createStudent('Leon', '', 'Maier', '2018-06-02', 'Musterstraße 1 12345 Musterhausen', 'Mondschein', Uint8List(0),
        [Caregiver('Beate', 'Maier', 'Oma', {'Handy Arbeit': '0160654321', 'Handy Privat': '0160123456'}, 'Beate.Maier@beispiel.de'),
          Caregiver('Daniel', 'Maier', 'Opa', {'Handy Arbeit': '0175654321', 'Handy Privat': '0175123456'}, 'Daniel.Maier@beispiel.de')],
        {'Pinnwand', 'Zeitung', 'Website'}
    );
    createStudent('Mia', '', 'Fischer', '2018-05-03', 'Musterstraße 1 12345 Musterhausen', 'Regenbogen', Uint8List(0),
        [Caregiver('Marlene', 'Fischer', 'Mama', {'Handy Arbeit': '0160654321', 'Handy Privat': '0160123456'}, 'Marlene.Fischer@beispiel.de'),
          Caregiver('Alfons', 'Fischer', 'Papa', {'Handy Arbeit': '0175654321', 'Handy Privat': '0175123456'}, 'Alfons.Fischer@beispiel.de')],
        {'Pinnwand', 'Zeitung', 'Website'}
    );
    createStudent('Anna', '', 'Müller', '2018-02-01', 'Musterstraße 1 12345 Musterhausen', 'Regenbogen', Uint8List(0),
        [Caregiver('Franziska', 'Müller', 'Mama', {'Handy Arbeit': '0160654321', 'Handy Privat': '0160123456'}, 'Franziska.Mueller@beispiel.de'),
          Caregiver('Bernd', 'Müller', 'Papa', {'Handy Arbeit': '0175654321', 'Handy Privat': '0175123456'}, 'Bernd.Mueller@beispiel.de')],
        {'Pinnwand', 'Zeitung', 'Website'}
    );
    createStudent('Emma', '', 'Schneider', '2018-04-15', 'Musterstraße 1 12345 Musterhausen', 'Mondschein', Uint8List(0),
        [Caregiver('Maria', 'Schneider', 'Mama', {'Handy Arbeit': '0160654321', 'Handy Privat': '0160123456'}, 'Maria.Schneider@beispiel.de'),
          Caregiver('Johannes', 'Schneider', 'Papa', {'Handy Arbeit': '0175654321', 'Handy Privat': '0175123456'}, 'Johannes.Schneider@beispiel.de')],
        {'Pinnwand', 'Zeitung', 'Website'}
    );
    createStudent('Jonas', '', 'Wagner', '2017-08-12', 'Musterstraße 1 12345 Musterhausen', 'Regenbogen', Uint8List(0),
        [Caregiver('Johanna', 'Wagner', 'Mama', {'Handy Arbeit': '0160654321', 'Handy Privat': '0160123456'}, 'Johanna.Wagner@beispiel.de'),
          Caregiver('Sebastian', 'Wagner', 'Papa', {'Handy Arbeit': '0175654321', 'Handy Privat': '0175123456'}, 'Sebastian.Wagner@beispiel.de')],
        {'Pinnwand', 'Zeitung', 'Website'}
    );
    createStudent('Adam', '', 'Hoffmann', '2017-12-05', 'Musterstraße 1 12345 Musterhausen', 'Regenbogen', Uint8List(0),
        [Caregiver('Sabrina', 'Hoffmann', 'Mama', {'Handy Arbeit': '0160654321', 'Handy Privat': '0160123456'}, 'Sabrina.Hoffmann@beispiel.de'),
          Caregiver('Markus', 'Hoffmann', 'Papa', {'Handy Arbeit': '0175654321', 'Handy Privat': '0175123456'}, 'Markus.Hoffmann@beispiel.de')],
        {'Pinnwand', 'Zeitung', 'Website'}
    );
    createStudent('Ben', '', 'Becker', '2018-01-12', 'Musterstraße 1 12345 Musterhausen', 'Sonnenschein', Uint8List(0),
        [Caregiver('Karin', 'Becker', 'Mama', {'Handy Arbeit': '0160654321', 'Handy Privat': '0160123456'}, 'Karin.Becker@beispiel.de'),
          Caregiver('Christian', 'Becker', 'Papa', {'Handy Arbeit': '0175654321', 'Handy Privat': '0175123456'}, 'Christian.Becker@beispiel.de')],
        {'Pinnwand', 'Zeitung', 'Website'}
    );
    createStudent('Lara', '', 'Weber', '2018-10-30', 'Musterstraße 1 12345 Musterhausen', 'Sonnenschein', Uint8List(0),
        [Caregiver('Martina', 'Weber', 'Mama', {'Handy Arbeit': '0160654321', 'Handy Privat': '0160123456'}, 'Martina.Weber@beispiel.de'),
          Caregiver('Joseph', 'Weber', 'Papa', {'Handy Arbeit': '0175654321', 'Handy Privat': '0175123456'}, 'Joseph.Weber@beispiel.de')],
        {'Pinnwand', 'Zeitung', 'Website'}
    );
  }

  Future<Uint8List> randomImage(String studentId) async {
    int hashValue = studentId.hashCode.abs();
    String image = 'assets${Platform.pathSeparator}images${Platform.pathSeparator}';

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
      //image += 'lion.png'; TODO: lion not available
        image += 'koala.png';
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

    // add padding to default images to prevent from clipping in AttendanceScreen and ShowStudentScreen
    ByteData bytes = await rootBundle.load(image);
    Uint8List list = bytes.buffer.asUint8List();
    Image? decodedImage = PngDecoder().decodeImage(list);
    Image paddedImage = Image(600, 600);
    paddedImage.fill(Color.fromRgba(0, 0, 0, 0));
    if (decodedImage != null) {
      for (int y = 0; y < paddedImage.height; y++) {
        for (int x = 0; x < paddedImage.width; x++) {
          if ((x >= 44 && x < 556) && (y >= 44 && y < 556)) {
            paddedImage.setPixel(x, y, decodedImage.getPixel(x - 44, y - 44));
          }
        }
      }
    }
    list = Uint8List.fromList(PngEncoder().encodeImage(paddedImage));
    return list;
  }
}