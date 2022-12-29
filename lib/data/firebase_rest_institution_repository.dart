import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:kinga/constants/keys.dart';
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
  Future<void> joinInstitution(String institutionId, String institutionPassword) async {
    final kdf = CryptoUtils.getKdf();
    late final Uint8List encryptedInstitutionKey;
    late final Uint8List institutionKeyIv;
    late final Uint8List passwordKeyNonce;
    late final Uint8List verificationKey;

    var response = await http.get(Uri.https(firebaseFirestoreUrl, "v1/projects/kinga-a6510/databases/(default)/documents/Institution/$institutionId"));

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      var values = result['fields'];
      encryptedInstitutionKey = base64.decode(values[Keys.encryptedInstitutionKey]['stringValue']);
      institutionKeyIv = base64.decode(values[Keys.institutionKeyIv]['stringValue']);
      passwordKeyNonce = base64.decode(values[Keys.passwordKeyNonce]['stringValue']);
      verificationKey = base64.decode(values[Keys.verificationKey]['stringValue']);
    } else {
      return; // TODO
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
      // generate tmpKey from institutionPassword
      final Uint8List tmpKey = Uint8List.fromList(await (await kdf.deriveKey(secretKey: SecretKey(utf8.encode(institutionPassword)), nonce: passwordKeyNonce)).extractBytes()); // 256 bit

    // split tmpKey in passwordKey and verificationKey
    final Uint8List passwordKey = Uint8List.fromList(tmpKey.getRange(0, 16).toList());
    final Uint8List verificationKey2 = Uint8List.fromList(tmpKey.getRange(16, 32).toList());

    // check verificationKey
    if (verificationKey.join('') == verificationKey2.join('')) {
      // if verificationKey valid
      // decrypt encryptedInstitutionKey
      final Encrypter encrypter = Encrypter(AES(Key(passwordKey)));
      final String institutionKey = encrypter.decrypt(Encrypted(encryptedInstitutionKey), iv: IV(institutionKeyIv));
      GetIt.instance.get<StreamingSharedPreferences>().setString(Keys.institutionKey, institutionKey);
      GetIt.instance.get<StreamingSharedPreferences>().setString(Keys.institutionId, institutionId); // TODO: maybe decode Base64
    } else {
      // if verificationKey invalid
      // TODO
    }
  }
  }

  @override
  void leaveInstitution() {
    // TODO: implement leaveInstitution
  }


}
