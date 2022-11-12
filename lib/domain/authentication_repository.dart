import 'package:kinga/domain/entity/user.dart';

abstract class AuthenticationRepository {
  /// Returns null if successful, an human readable error message otherwise. */
  Future<String?> signInWithEmailAndPassword(String email, String password);

  /// Returns null if successful, an human readable error message otherwise. */
  Future<String?> createUserWithEmailAndPassword(email, password);

  Future signOut();

  Stream<User?> authStateChanges();
}