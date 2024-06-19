class User {

  String userId;
  String email;

  User(this.userId, this.email);

  User.fromJson(Map<String, dynamic> json) : userId = json['userId'], email = json['email'];

  Map<String, dynamic> toJson() => {'userId': userId, 'email': email};

}
