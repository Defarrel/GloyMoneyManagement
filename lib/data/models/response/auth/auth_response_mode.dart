import 'dart:convert';

class AuthResponseModel {
  final String? token;
  final User? user;

  AuthResponseModel({
    this.token,
    this.user,
  });

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        token: json["token"],
        user: json["user"] == null ? null : User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "token": token,
        "user": user?.toMap(),
      };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? role;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "role": role,
      };
}
