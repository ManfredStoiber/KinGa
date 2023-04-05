import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:kinga/constants/strings.dart';
import 'package:kinga/domain/authentication_repository.dart';
import 'package:kinga/domain/entity/user.dart' as kinga;

class FirebaseAuthenticationRepository implements AuthenticationRepository {

  final FirebaseAuth _auth = GetIt.I<FirebaseAuth>();

  FirebaseAuthenticationRepository();

  @override
  Future<String?> createUserWithEmailAndPassword(email, password) async {
    // TODO: maybe change error handling to .onerror or so
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch(e) {
      switch (e.code) {
        case Strings.firebaseErrorEmailAlreadyInUse:
          return Strings.errorEmailAlreadyInUse;
        case Strings.firebaseErrorInvalidEmail:
          return Strings.errorInvalidEmail;
        case Strings.firebaseErrorWeakPassword:
          return Strings.errorWeakPassword;
        case Strings.firebaseErrorNetworkRequestFailed:
          return Strings.errorNetwork;
        case Strings.firebaseErrorOperationNotAllowed:
        default:
          return "${Strings.errorUnexpected}. Fehlercode: ${e.code}";
      }
    } catch(e) {
      return "${Strings.errorUnexpected}. Fehler: ${e.toString()}";
    }
  }

  @override
  Future<String?> signInWithEmailAndPassword(String email, String password) async {
    // TODO: maybe change error handling to .onerror or so
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case Strings.firebaseErrorInvalidEmail:
        case Strings.firebaseErrorWrongPassword:
          return Strings.errorInvalidEmailOrPassword;
        case Strings.firebaseErrorUserDisabled:
          return Strings.errorUserDisabled;
        case Strings.firebaseErrorUserNotFound:
          return Strings.errorUserNotFound;
        case Strings.firebaseErrorNetworkRequestFailed:
          return Strings.errorNetwork;
        default:
          return "${Strings.errorUnexpected}. Fehlercode: ${e.code}";
      }
    } catch(e) {
      return "${Strings.errorUnexpected}. Fehler: ${e.toString()}";
    }
  }

  @override
  Future signOut() {
    return _auth.signOut();
  }

  @override
  Stream<kinga.User?> authStateChanges() async* {
    await for (final user in _auth.authStateChanges()) {
      String? userId = user?.uid;
      String? email = user?.email;
      if (userId is String && email is String) {
        yield kinga.User(userId, email);
      } else {
        yield null;
      }
    }
  }

  @override
  kinga.User? getCurrentUser() {
    final user = _auth.currentUser;
    String? userId = user?.uid;
    String? email = user?.email;
    if (userId is String && email is String) {
      return kinga.User(userId, email);
    } else {
      return null;
    }
  }

}
