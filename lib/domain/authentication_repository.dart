import 'package:kinga/domain/entity/user.dart';

abstract class AuthenticationRepository {
  /// Returns null if successful, an human readable error message otherwise. */
  Future<String?> signIn();

  Future signOut();

  Stream<User?> authStateChanges();

  User? getCurrentUser();
}