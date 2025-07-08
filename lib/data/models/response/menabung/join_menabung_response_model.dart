import 'dart:convert';

class JointSavingResponseModel {
  final int id;
  final int savingId;
  final int userId;
  final int amount;
  final String contributorName;
  final String createdAt;
  final String? savingTitle;
  final String? userName;

  JointSavingResponseModel({
    required this.id,
    required this.savingId,
    required this.userId,
    required this.amount,
    required this.contributorName,
    required this.createdAt,
    this.savingTitle,
    this.userName,
  });

  factory JointSavingResponseModel.fromJson(String str) =>
      JointSavingResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JointSavingResponseModel.fromMap(Map<String, dynamic> map) =>
      JointSavingResponseModel(
        id: int.tryParse(map['id'].toString()) ?? 0,
        savingId: int.tryParse(map['saving_id'].toString()) ?? 0,
        userId: int.tryParse(map['user_id'].toString()) ?? 0,
        amount: double.tryParse(map['amount'].toString())?.round() ?? 0,
        contributorName: map['contributor_name'] ?? '',
        createdAt: map['created_at'] ?? '',
        savingTitle: map['saving_title'],
        userName: map['user_name'],
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "saving_id": savingId,
    "user_id": userId,
    "amount": amount,
    "contributor_name": contributorName,
    "created_at": createdAt,
    "saving_title": savingTitle,
    "user_name": userName,
  };
}
