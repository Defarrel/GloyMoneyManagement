import 'dart:convert';

class AkunRequestModel {
  final String name;
  final String email;
  final String role;

  AkunRequestModel({
    required this.name,
    required this.email,
    required this.role,
  });

  factory AkunRequestModel.fromJson(String str) =>
      AkunRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AkunRequestModel.fromMap(Map<String, dynamic> json) =>
      AkunRequestModel(
        name: json["name"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "email": email,
        "role": role,
      };
}
