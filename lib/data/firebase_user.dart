import 'package:kinga/domain/entity/user.dart';

class FirebaseUser extends User {

  String idToken;
  String refreshToken;
  String expiresIn;

  FirebaseUser(this.idToken, this.refreshToken, this.expiresIn, super.userId, super.email);

  FirebaseUser.fromJson(Map<String, dynamic> json) : idToken = json['idToken'], refreshToken = json['refreshToken'], expiresIn = json['expiresIn'], super.fromJson(json);

  Map<String, dynamic> toJson() => {'idToken': idToken, 'refreshToken': refreshToken, 'expiresIn': expiresIn, 'userId': userId, 'email': email};

}