import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:kinga/constants/keys.dart';
import 'package:kinga/data/firebase_authentication_repository.dart';
import 'package:kinga/data/firebase_rest_authentication_repository.dart';
import 'package:kinga/data/firebase_user.dart';
import 'package:kinga/data/firebase_utils.dart';
import 'package:kinga/domain/authentication_repository.dart';
import 'package:kinga/domain/entity/absence.dart';
import 'package:kinga/domain/entity/caregiver.dart';
import 'package:kinga/domain/entity/incidence.dart';
import 'package:kinga/domain/student_repository.dart';
import 'package:kinga/domain/entity/student.dart';
import 'package:kinga/util/crypto_utils.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FirebaseRestStudentRepository implements StudentRepository {

  final String firebaseFirestoreUrl = GetIt.I<String>(instanceName: Keys.firebaseFirestoreUrl);
  final String firebaseStorageUrl = GetIt.I<String>(instanceName: Keys.firebaseStorageUrl);
  final Map<String, Uint8List> _profileImagesCache = GetIt.I<Map<String, Uint8List>>(instanceName: Keys.profileImagesCache);
  final Directory _applicationDocumentsDirectory = GetIt.I<Directory>(instanceName: Keys.applicationDocumentsDirectory);

  cacheProfileImage(String studentId, Uint8List profileImage) {
    // cache profileImage
    _profileImagesCache[studentId] = profileImage;

    // store locally
    var file = File('${_applicationDocumentsDirectory.path}${Platform.pathSeparator}profileImages${Platform.pathSeparator}$studentId');
    file.create(recursive: true);
    file.writeAsBytes(profileImage);
  }

  Uint8List? getProfileImageFromCache(String studentId) {
    //print("Requested profile image from cache for studentId ${studentId}, is null: ${_profileImagesCache[studentId] == null}");
    return _profileImagesCache[studentId];
  }

  clearProfileImageCache() {
    _profileImagesCache.clear();
    Directory('${_applicationDocumentsDirectory.path}${Platform.pathSeparator}profileImages').delete(recursive: true);
  }

  @override
  Future<void> updateStudent(Student student) async {

    var authenticationRepository = GetIt.I<AuthenticationRepository>();
    var user = await (authenticationRepository as FirebaseRestAuthenticationRepository).getAuthenticatedUser();

    String institutionId = GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: "").getValue();
    Map<String, dynamic> studentEncrypted = FirebaseUtils.studentToMap(student);
    String body = json.encode({
      "name": "projects/kinga-a6510/databases/(default)/documents/Institution/$institutionId/Student/${student.studentId}",
      "fields": {"value": {"stringValue": studentEncrypted['value']}},
    });
    var response = await http.patch(Uri.https(firebaseFirestoreUrl, "v1/projects/kinga-a6510/databases/(default)/documents/Institution/$institutionId/Student/${student.studentId}"), // TODO: authorization header
      body: body,
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.idToken}'}
    );

    if (response.statusCode == 200) {
      // TODO
    } else {
      // TODO
    }

  }

  @override
  Stream<Set<Student>> watchStudents() async* {

    while (true) {

      var authenticationRepository = GetIt.I<AuthenticationRepository>();
      var user = await (authenticationRepository as FirebaseRestAuthenticationRepository).getAuthenticatedUser();

      String institutionId = GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: "").getValue();
      var response;
      try {
        response = await http.get(Uri.https(firebaseFirestoreUrl, "v1/projects/kinga-a6510/databases/(default)/documents/Institution/$institutionId/Student"), headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.idToken}'});
      } catch (err) {
        // retry in 10 seconds
        await Future.delayed(Duration(seconds: 10));
        continue;
      }

      if (response.statusCode == 200) {
        Set<Student> students = {};
        var result = json.decode(response.body);
        for (var doc in result['documents']) {
          Map<String, dynamic> decrypted = FirebaseUtils.decryptStudent(doc['fields']['value']['stringValue']);
          Student student = decrypted['student'];

          late Uint8List? profileImage;
          String? profileImageHash = decrypted['profileImage'];
          if (profileImageHash != null) {
            // get profileImage from cache if exists
            Uint8List? profileImageCache = (getProfileImageFromCache(student.studentId));
            //print("Is ProfileImage from cache == null: ${profileImageCache == null}");
            //print("Is hash code from cache equal to profileImageHash: ${profileImageCache != null && base64.encode(profileImageCache).hashCode.toString() == profileImageHash}");
            //print("Size of profileImageCache in Bytes: ${profileImageCache?.lengthInBytes}");
            //print("Hash from cache: ${base64.encode(profileImageCache!).hashCode.toString()}, profileImageHash: ${profileImageHash}");
            if (profileImageCache != null && base64.encode(profileImageCache).hashCode.toString() == profileImageHash) { // TODO: why is base64 faster than the alternatives below
              //if (profileImageCache != null && profileImageCache.toString().hashCode.toString() == profileImageHash) {
              //if (profileImageCache != null && sha1.convert(profileImageCache).toString() == profileImageHash) {
              //print("Using profileImage from cache");
              profileImage = profileImageCache;
            } else {
              Uint8List? profileImageDownload = null;

              //print("Downloading profileImage");
              var response = await http.get(Uri(scheme: 'https', host: firebaseStorageUrl, path: 'v0/b/kinga-a6510.appspot.com/o/${institutionId}%2F${student.studentId}', query: 'alt=media'), headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.idToken}'});
              //var response = await http.get('$firebaseStorageUrl/v0/b/kinga-a6510.appspot.com/o/${institutionId}%2F${student.studentId}?alt=media', headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.idToken}'});

              if (response.statusCode == 200) {
                profileImageDownload = response.bodyBytes;
              }

              if (profileImageDownload != null) {
                //print("Using downloaded image");
                profileImage = profileImageDownload;
                // decrypt profileImage
                try {
                  profileImage =
                      Uint8List.fromList(base64.decode(CryptoUtils.decrypt(
                          utf8.decode(profileImageDownload))));
                } catch (e) {
                  // if decryption failed, image is stored unencrypted // TODO: remove when everything is encrypted
                  profileImage = profileImageDownload;
                }
                cacheProfileImage(student.studentId, profileImage); // store image in cache
              } else {
                profileImage = null;
              }
            }
          } else {
            profileImage = null;
          }
          student.profileImage = profileImage;

          students.add(student);
        }
        yield students;
      }

      await Future.delayed(const Duration(seconds: 2));
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

  @override
  Future<String?> getStudentIdFromRfid(String rfid) async {
    rfid = rfid.trim();
    var authenticationRepository = GetIt.I<AuthenticationRepository>();
    var user = await (authenticationRepository as FirebaseRestAuthenticationRepository).getAuthenticatedUser();

    String institutionId = GetIt.I<StreamingSharedPreferences>().getString(Keys.institutionId, defaultValue: "").getValue();
    var response = await http.get(Uri.https(firebaseFirestoreUrl, "v1/projects/kinga-a6510/databases/(default)/documents/Institution/$institutionId"), headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.idToken}'});

    if (response.statusCode == 200) {
      //print(response.body);
      var result = json.decode(response.body);
      var values = result['fields'];
      var rfids = values['rfid']['mapValue']['fields'];
      //print("Rfids: ${rfids}");
      if (rfids == null) {
        rfids = {};
      }
      //print("Returning value for rfid \"${rfid}\" ${rfids[rfid]?['stringValue']}");
      return rfids[rfid]?['stringValue'];
    } else {
      //print("Returning Null");
      return null;
    }
}

}