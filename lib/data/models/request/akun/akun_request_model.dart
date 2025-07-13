import 'dart:convert';

class AkunRequestModel {
  final String name;
  final String email;
  final String role;
  final String? password;
  final String? photo; 

  AkunRequestModel({
    required this.name,
    required this.email,
    required this.role,
    this.password,
    this.photo,
  });

  factory AkunRequestModel.fromJson(String str) =>
      AkunRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AkunRequestModel.fromMap(Map<String, dynamic> json) =>
      AkunRequestModel(
        name: json["name"],
        email: json["email"],
        role: json["role"],
        password: json["password"],
        photo: json["photo_profile"],
      );

  Map<String, dynamic> toMap() {
    final map = {"name": name, "email": email, "role": role};
    if (password != null) map["password"] = password ?? "";
    if (photo != null) map["photo_profile"] = photo as String;
    return map;
  }
}
