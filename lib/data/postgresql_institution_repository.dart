import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart';
import 'package:kinga/constants/keys.dart';
import 'package:kinga/domain/institution_repository.dart';
import 'package:kinga/generated/backend.pbgrpc.dart' as gen;
import 'package:kinga/util/crypto_utils.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class PostgreSQLInstitutionRepository implements InstitutionRepository {
  late gen.BackendClient stub;

  PostgreSQLInstitutionRepository() {
    final channel = ClientChannel(
      Keys.serverIpAddress,
      port: Keys.port,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    stub = gen.BackendClient(channel);
  }

  @override
  Future<String?> createInstitution(String institutionName, String institutionPassword) async {
    String? institutionId = await generateInstitutionId(institutionName);
    bool success = false;

    final kdf = CryptoUtils.getKdf();

    final Uint8List passwordKeyNonce = Uint8List.fromList(List.generate(8, (index) => Random.secure().nextInt(256))); // 64 bit
    final Uint8List tmpKey = Uint8List.fromList(await (await kdf.deriveKey(secretKey: SecretKey(utf8.encode(institutionPassword)), nonce: passwordKeyNonce)).extractBytes()); // 256 bit
    final Uint8List passwordKey = Uint8List.fromList(tmpKey.getRange(0, 16).toList());
    final Uint8List verificationKey = Uint8List.fromList(tmpKey.getRange(16, 32).toList());

    final Key institutionKey = Key.fromSecureRandom(16);
    final IV institutionKeyIv = IV.fromSecureRandom(16);
    final Encrypter encrypter = Encrypter(AES(Key(passwordKey)));
    final Encrypted encryptedInstitutionKey = encrypter.encrypt(institutionKey.base64, iv: institutionKeyIv);

    await stub.createInstitution(gen.Institution()
        ..institutionId = institutionId
        ..institutionName = institutionName
        ..encryptedInstitutionKey = encryptedInstitutionKey.base64
        ..institutionKeyIv = institutionKeyIv.base64
        ..passwordKeyNonce = base64.encode(passwordKeyNonce)
        ..verificationKey = base64.encode(verificationKey)
    ).then((value) => success = true);

    if (success) {
      return institutionId;
    } else {
      return null;
    }
  }

  @override
  Future<String?> joinInstitution(String institutionId, String institutionPassword) async {
    final kdf = CryptoUtils.getKdf();
    late final Uint8List encryptedInstitutionKey;
    late final Uint8List institutionKeyIv;
    late final Uint8List passwordKeyNonce;
    late final Uint8List verificationKey;

    // TODO: implement error-handling
    await stub.retrieveInstitution(gen.Id()..requestId = institutionId).then((value) {
      encryptedInstitutionKey = base64.decode(value.encryptedInstitutionKey);
      institutionKeyIv = base64.decode(value.institutionKeyIv);
      passwordKeyNonce = base64.decode(value.passwordKeyNonce);
      verificationKey = base64.decode(value.verificationKey);
    });

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
      GetIt.instance.get<StreamingSharedPreferences>().setString(Keys.institutionId, institutionId);
    } else {
      // if verificationKey invalid
      // TODO
    }
  }
  }

  @override
  void leaveInstitution() {
    GetIt.instance.get<StreamingSharedPreferences>().remove(Keys.institutionId);
    //GetIt.I<Preference<String>>(instanceName: Keys.institutionId).setValue("");
  }

  Future<String> generateInstitutionId(String institutionName) async {
    // TODO: generate Id based on institutionName
    const letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const numbers = '0123456789';

    String institutionId;

    // check if id is unique
    do {
      institutionId = List.generate(2, (index) {
        final indexRandom = Random.secure().nextInt(letters.length);
        return letters[indexRandom];
      }).join('');

      institutionId += List.generate(3, (index) {
        final indexRandom = Random.secure().nextInt(numbers.length);
        return numbers[indexRandom];
      }).join('');
    }
    while ((await (stub.retrieveInstitution(gen.Id()..requestId=institutionId))).institutionId != '');

    return institutionId;
  }
}