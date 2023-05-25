import 'package:get_it/get_it.dart';
import 'package:kinga/domain/authentication_repository.dart';
import 'package:kinga/domain/entity/user.dart';

class AuthenticationService {

  final AuthenticationRepository _authenticationRepository = GetIt.I<AuthenticationRepository>();

  Future signIn() async {
    return _authenticationRepository.signIn();
  }

  Future signOut() async {
    return _authenticationRepository.signOut();
  }

  Stream<User?> authStateChanges() {
    return _authenticationRepository.authStateChanges();
  }

  User? getCurrentUser() {
    return _authenticationRepository.getCurrentUser();
  }

}