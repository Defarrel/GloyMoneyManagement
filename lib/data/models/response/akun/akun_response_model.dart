import 'dart:convert';

class AkunResponseModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? photoProfile;

  AkunResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoProfile,
  });

  factory AkunResponseModel.fromMap(Map<String, dynamic> map) {
    return AkunResponseModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      role: map['role'],
      photoProfile: map['photo_profile'], 
    );
  }

  factory AkunResponseModel.fromJson(String source) =>
      AkunResponseModel.fromMap(json.decode(source));
}
