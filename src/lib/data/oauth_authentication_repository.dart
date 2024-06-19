import 'dart:async';
import 'dart:convert';

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/authentication_repository.dart';
import 'package:kinga/domain/entity/user.dart';
import 'package:logger/logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../constants/backend_config.dart';
import '../constants/keys.dart';

class OAuthAuthenticationRepository implements AuthenticationRepository {

  final logger = Logger();

  final FlutterAppAuth _auth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final StreamingSharedPreferences _streamingSharedPreferences = GetIt.instance.get<StreamingSharedPreferences>();
  User? user;

  final StreamController<User?> _authStreamController = StreamController();

  OAuthAuthenticationRepository() {
    user = _streamingSharedPreferences.getCustomValue<User?>("authenticatedUser", defaultValue: null, adapter: JsonAdapter(
      deserializer: (value) => User.fromJson((value as Map<String, dynamic>)),
    )).getValue();
    _authStreamController.add(user);
  }

  @override
  Future<String?> signIn() async {

    try {
      final AuthorizationTokenResponse? result = await _auth
          .authorizeAndExchangeCode(
          AuthorizationTokenRequest(
              'kinga-app', 'com.stoibersoftware.kinga://kinga',
              //'kinga-app', 'https://kinga-webapp.web.app', // TODO: check why app link not working
              discoveryUrl: BackendConfig.discoveryUrl,
              //scopes: ['openid', 'profile', 'email', 'offline_access', 'api'],
              scopes: ['openid', 'profile', 'email', 'offline_access'],
          )
      );
      if (result == null || result.idToken == null || result.refreshToken == null || result.accessTokenExpirationDateTime == null) {
        return Strings.errorUnexpected;
      }
      storeTokens(result);
      return null;
    } catch (e) {
      return e.toString();
    }

  }

  @override
  Future signOut() async {
    try {
      if (user != null) {
        _streamingSharedPreferences.remove('authenticatedUser');
        final idToken = await _secureStorage.read(key: Keys.idToken);
        await _auth.endSession(
            EndSessionRequest(
              idTokenHint: idToken,
              discoveryUrl: BackendConfig.discoveryUrl,
              postLogoutRedirectUrl: "com.stoibersoftware.kinga://kinga/signout",
            ));
        user = null;
        _authStreamController.add(null);
      }
    } catch(e) {
      logger.e(e);
    }
    return;
  }

  @override
  Stream<User?> authStateChanges() {
    return _authStreamController.stream;
  }

  @override
  User? getCurrentUser() {
    return user;
  }

  Map<String, dynamic> decodeJwt(String jwt) {
    return json.decode(utf8.decode(base64Url.decode(base64Url.normalize(jwt.split(".")[1]))));
  }

  Future<String?> getAccessToken() async {
    final String? accessToken = await _secureStorage.read(key: Keys.accessToken);
    // check if valid accessToken available
    if (accessToken != null && getExpirationTime(accessToken).isAfter(DateTime.now())) {
      return accessToken;
    }

    // check if valid refreshToken available
    final String? refreshToken = await _secureStorage.read(key: Keys.refreshToken);
    if (refreshToken != null) {
      // refresh tokens
      await refreshTokens();
      return getAccessToken();
    }

    // sign in if no token available
    await signIn();
    return getAccessToken();
  }

  storeTokens(TokenResponse response) {
    var idTokenDecoded = decodeJwt(response.idToken!);
    user = User(idTokenDecoded['sub'], idTokenDecoded['preferred_username']);
    _streamingSharedPreferences.setCustomValue<User>('authenticatedUser', user!, adapter: const JsonAdapter());
    _secureStorage.write(key: Keys.accessToken, value: response.accessToken);
    _secureStorage.write(key: Keys.refreshToken, value: response.refreshToken);
    _secureStorage.write(key: Keys.idToken, value: response.idToken);
    _authStreamController.add(user);
  }

  Future refreshTokens() async {
    final refreshToken = await _secureStorage.read(key: Keys.refreshToken);
    final TokenResponse? result = await _auth.token(TokenRequest(
      'kinga-app', 'com.stoibersoftware.kinga://kinga',
      refreshToken: refreshToken,
      discoveryUrl: BackendConfig.discoveryUrl,
    ));
    storeTokens(result!);
  }

  DateTime getExpirationTime(String token) {
    return DateTime.fromMillisecondsSinceEpoch(decodeJwt(token)['exp'] * 1000);
  }

}
