import 'dart:async';
import 'dart:convert';
import 'package:get_it/get_it.dart';

import 'package:kinga/constants/keys.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/data/firebase_user.dart';
import 'package:kinga/domain/authentication_repository.dart';
import 'package:http/http.dart' as http;
import 'package:kinga/domain/entity/user.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

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

  Future<FirebaseUser> getAuthenticatedUser() async {
    FirebaseUser? user = GetIt.I<StreamingSharedPreferences>().getCustomValue<FirebaseUser?>('authenticatedUser', defaultValue: null, adapter: JsonAdapter(
      deserializer: (value) => FirebaseUser.fromJson((value as Map<String, dynamic>)),
    )).getValue();
    if (user != null) {
      var expirationDateTime = DateTime.fromMillisecondsSinceEpoch(json.decode(utf8.decode(base64.decode(base64Url.normalize(user.idToken.split('.')[1]))))['exp'] * 1000 - (10 * 60 * 1000));
      if (DateTime.now().isAfter(expirationDateTime)) { // if 10 minutes before expires, refresh token
        // refresh idToken
        await refreshAuthentication();
        user = GetIt.I<StreamingSharedPreferences>().getCustomValue<FirebaseUser?>('authenticatedUser', defaultValue: null, adapter: JsonAdapter(
          deserializer: (value) => FirebaseUser.fromJson((value as Map<String, dynamic>)),
        )).getValue();
        return user!;
      } else {
        return user;
      }
    }

    throw Error(); // TODO
  }

  Future<void> refreshAuthentication() async {
    FirebaseUser? user = GetIt.I<StreamingSharedPreferences>().getCustomValue<FirebaseUser?>('authenticatedUser', defaultValue: null, adapter: JsonAdapter(
      deserializer: (value) => FirebaseUser.fromJson((value as Map<String, dynamic>)),
    )).getValue();

    if (user != null) {
      var response;
      while (response == null) {
        try {
          response = await http.post(Uri.https(
              'securetoken.googleapis.com', "v1/token", {'key': apiKey}),
              body: {
                'grant_type': 'refresh_token',
                'refresh_token': user.refreshToken,
              });
        } catch (err) {
          // retry in 10 seconds
          await Future.delayed(Duration(seconds: 5));
          continue;
        }
      }

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        FirebaseUser newUser = FirebaseUser(result['id_token'], result['refresh_token'], result['expires_in'], user.userId, user.email);
        GetIt.instance.get<StreamingSharedPreferences>().setCustomValue<FirebaseUser>('authenticatedUser', newUser, adapter: JsonAdapter());
      } else {
        return; // TODO
      }
    }

  }

  @override
  Stream<User?> authStateChanges() {
    if (streamController == null) {
      streamController = StreamController<User?>();
      getAuthenticatedUser().then((user) =>
          streamController!.add(user)
      );
    }
    return streamController!.stream;
  }

  @override
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    var response;
    try {
      response = await http.post(
          Uri.https(url, "v1/accounts:signInWithPassword", {'key': apiKey}),
          body: {
            'email': email,
            'password': password,
            'returnSecureToken': 'true'
          });
    } catch (err) {
      return "Keine Verbindung";
    }

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      FirebaseUser user = FirebaseUser(result['idToken'], result['refreshToken'], result['expiresIn'], result['localId'], result['email']);
      GetIt.instance.get<StreamingSharedPreferences>().setCustomValue<FirebaseUser>('authenticatedUser', user, adapter: JsonAdapter());
      streamController!.add(user);
    } else if (response.statusCode == 400){
      var result = json.decode(response.body);
      var errorMessage = result['error']['message'];
      if (errorMessage == "INVALID_EMAIL" || errorMessage == "INVALID_PASSWORD") {
        return Strings.errorInvalidEmailOrPassword;
      }
      return "Ein unbekannter Fehler ist aufgetreten"; // TODO
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
