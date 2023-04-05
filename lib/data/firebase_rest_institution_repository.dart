import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:kinga/constants/keys.dart';
import 'package:kinga/data/firebase_rest_authentication_repository.dart';
import 'package:kinga/domain/authentication_repository.dart';
import 'package:kinga/domain/institution_repository.dart';
import 'package:kinga/util/crypto_utils.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class FirebaseRestInstitutionRepository implements InstitutionRepository {

  final String firebaseFirestoreUrl = GetIt.I<String>(instanceName: Keys.firebaseFirestoreUrl);
  @override
  Future<String> createInstitution(String name, String institutionPassword) {
    // TODO: implement createInstitution
    throw UnimplementedError();
  }

  Future<String> generateInstitutionId() {
    // TODO: implement generateInstitutionId
    throw UnimplementedError();
  }

  @override
  Future<String?> joinInstitution(String institutionId, String institutionPassword) async {
    var authenticationRepository = GetIt.I<AuthenticationRepository>();
    var user = await (authenticationRepository as FirebaseRestAuthenticationRepository).getAuthenticatedUser();

    final kdf = CryptoUtils.getKdf();
    late final Uint8List encryptedInstitutionKey;
    late final Uint8List institutionKeyIv;
    late final Uint8List passwordKeyNonce;
    late final Uint8List verificationKey;

    cupertino.debugPrint("Send request to firebaseFirestoreUrl");
    var response = await http.get(Uri.https(firebaseFirestoreUrl, "v1/projects/kinga-a6510/databases/(default)/documents/Institution/$institutionId"), headers: {HttpHeaders.authorizationHeader: 'Bearer ${user.idToken}'});

    cupertino.debugPrint("Got response. Checking statusCode");
    if (response.statusCode == 200) {
      cupertino.debugPrint("StatusCode == 200!");
      var result = json.decode(response.body);
      cupertino.debugPrint("Result: $result");
      var values = result['fields'];
      cupertino.debugPrint("values: $values");
      encryptedInstitutionKey = base64.decode(values[Keys.encryptedInstitutionKey]['stringValue']);
      institutionKeyIv = base64.decode(values[Keys.institutionKeyIv]['stringValue']);
      passwordKeyNonce = base64.decode(values[Keys.passwordKeyNonce]['stringValue']);
      verificationKey = base64.decode(values[Keys.verificationKey]['stringValue']);
      cupertino.debugPrint("Got Encryption stuff!");
    } else {
      cupertino.debugPrint("StatusCode = ${response.statusCode}");
      return "TODO"; // TODO
    }


    /*
    await db.collection('Institution').doc(institutionId).get().then((value) {
      encryptedInstitutionKey = base64.decode(value[Keys.encryptedInstitutionKey]);
      institutionKeyIv = base64.decode(value[Keys.institutionKeyIv]);
      passwordKeyNonce = base64.decode(value[Keys.passwordKeyNonce]);
      verificationKey = base64.decode(value[Keys.verificationKey]);
    },);

     */

    if (institutionPassword != "") {
      cupertino.debugPrint("institutionPassword != \"\"");
      // generate tmpKey from institutionPassword
      final Uint8List tmpKey = Uint8List.fromList(await (await kdf.deriveKey(secretKey: SecretKey(utf8.encode(institutionPassword)), nonce: passwordKeyNonce)).extractBytes()); // 256 bit

      // split tmpKey in passwordKey and verificationKey
      final Uint8List passwordKey = Uint8List.fromList(tmpKey.getRange(0, 16).toList());
      final Uint8List verificationKey2 = Uint8List.fromList(tmpKey.getRange(16, 32).toList());
      cupertino.debugPrint("got passwordKey and verificationKey2");

      // check verificationKey
      if (verificationKey.join('') == verificationKey2.join('')) {
        cupertino.debugPrint("verificationKey valid");
        // if verificationKey valid
        // decrypt encryptedInstitutionKey
        final Encrypter encrypter = Encrypter(AES(Key(passwordKey)));
        final String institutionKey = encrypter.decrypt(Encrypted(encryptedInstitutionKey), iv: IV(institutionKeyIv));
        cupertino.debugPrint("Got institutionKey");
        GetIt.instance.get<StreamingSharedPreferences>().setString(Keys.institutionKey, institutionKey);
        GetIt.instance.get<StreamingSharedPreferences>().setString(Keys.institutionId, institutionId); // TODO: maybe decode Base64
        cupertino.debugPrint("Set institutionKey");
      } else {
        // if verificationKey invalid
        cupertino.debugPrint("verificationKey invalid");
        return "TODO"; // TODO
      }
    }
  }

  @override
  void leaveInstitution() {
    // TODO: implement leaveInstitution
  }


}
