import 'dart:async';
import 'dart:convert';
import 'package:get_it/get_it.dart';

import 'package:kinga/constants/keys.dart';
import 'package:kinga/domain/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'package:kinga/domain/entity/user.dart';

class FirebaseRestAuthenticationRepository implements AuthenticationRepository {

  String url = GetIt.I<String>(instanceName: Keys.firebaseAuthUrl);
  String apiKey = GetIt.I<String>(instanceName: Keys.firebaseApiKey);
  StreamController<User?>? streamController;

  FirebaseRestAuthenticationRepository();

  @override
  Future<String?> createUserWithEmailAndPassword(email, password) {
    // TODO: implement createUserWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Stream<User?> authStateChanges() {
    streamController ??= StreamController<User?>();
    return streamController!.stream;
  }

  @override
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    var response = await http.post(Uri.https(url, "v1/accounts:signInWithPassword", {'key': apiKey}), body: {
      'email': email,
      'password': password,
      'returnSecureToken': 'true'
    });

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      streamController!.add(User(result['localId'], result['email']));
      streamController!.hasListener;
    } else {
      return "Error <TODO>"; // TODO
    }

    return null;
  }

  @override
  Future signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  User? getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

}
