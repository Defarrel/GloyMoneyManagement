import 'dart:convert';

class AkunResponseModel {
  final int id;
  final String name;
  final String email;
  final String role;

  AkunResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AkunResponseModel.fromJson(String str) =>
      AkunResponseModel.fromMap(json.decode(str));

  factory AkunResponseModel.fromMap(Map<String, dynamic> json) =>
      AkunResponseModel(
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
