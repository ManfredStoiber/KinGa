import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/keys.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class CryptoUtils {

  static final lengthOfBase64EncodedIv = IV(createIv()).base64.length;

  static String encrypt(String data) {
    final institutionKey = base64.decode(GetIt.instance.get<StreamingSharedPreferences>().getString(Keys.institutionKey, defaultValue: "").getValue());
    final Encrypter encrypter = Encrypter(AES(Key(institutionKey)));
    final iv = createIv();
    final cipher = encrypter.encrypt(data, iv: IV(iv)).base64;

    return base64.encode(iv) + cipher;
  }

  static String decrypt(String ivPlusCipher) {
    final institutionKey = base64.decode(GetIt.instance.get<StreamingSharedPreferences>().getString(Keys.institutionKey, defaultValue: "").getValue());
    final Encrypter encrypter = Encrypter(AES(Key(institutionKey)));
    final iv = ivPlusCipher.substring(0, lengthOfBase64EncodedIv);
    final cipher = ivPlusCipher.substring(lengthOfBase64EncodedIv);
    final data = encrypter.decrypt(Encrypted.fromBase64(cipher), iv: IV.fromBase64(iv));

    return data;
  }

  static Uint8List createIv() {
    return IV.fromSecureRandom(16).bytes;
  }

  static Pbkdf2 getKdf() {
    return Pbkdf2(iterations: 100000, bits: 256, macAlgorithm: Hmac.sha256());
  }
}