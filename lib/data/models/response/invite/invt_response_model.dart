import 'dart:convert';

class InvtResponseModel {
  final int id;
  final String savingTitle;
  final String senderName;
  final String status;
  final DateTime createdAt;

  InvtResponseModel({
    required this.id,
    required this.savingTitle,
    required this.senderName,
    required this.status,
    required this.createdAt,
  });

  factory InvtResponseModel.fromJson(String str) =>
      InvtResponseModel.fromMap(json.decode(str));

  factory InvtResponseModel.fromMap(Map<String, dynamic> json) =>
      InvtResponseModel(
        id: json["id"],
        savingTitle: json["saving_title"],
        senderName: json["sender_name"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "saving_title": savingTitle,
        "sender_name": senderName,
        "status": status,
        "created_at": createdAt.toIso8601String(),
      };
}
