import 'package:kinga/domain/entity/user.dart';

class OauthUser extends User {

  String idToken;
  String refreshToken;
  String accessTokenExpirationDateTime ;

  OauthUser(this.idToken, this.refreshToken, this.accessTokenExpirationDateTime, super.userId, super.email);

  OauthUser.fromJson(Map<String, dynamic> json) : idToken = json['idToken'], refreshToken = json['refreshToken'], accessTokenExpirationDateTime = json['accessTokenExpirationDateTime'], super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {'idToken': idToken, 'refreshToken': refreshToken, 'accessTokenExpirationDateTime': accessTokenExpirationDateTime, 'userId': userId, 'email': email};

}