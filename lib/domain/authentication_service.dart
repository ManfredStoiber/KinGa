import 'package:kinga/domain/authentication_repository.dart';
import 'package:kinga/domain/entity/user.dart';

class AuthenticationService {

  final AuthenticationRepository _authenticationRepository;
  AuthenticationService(this._authenticationRepository);

  Future signInWithEmailAndPassword(String email, String password) async {
    return _authenticationRepository.signInWithEmailAndPassword(email, password);
  }

  Future createUserWithEmailAndPassword(email, password) async {
    return _authenticationRepository.createUserWithEmailAndPassword(email, password);
  }

  Future signOut() async {
    return _authenticationRepository.signOut();
  }

  Stream<User?> authStateChanges() {
    return _authenticationRepository.authStateChanges();
  }

}