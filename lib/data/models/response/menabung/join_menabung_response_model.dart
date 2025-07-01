import 'dart:convert';

class JointSavingResponseModel {
  final int id;
  final int savingId;
  final int userId;
  final int amount;
  final String contributorName;
  final String createdAt;

  JointSavingResponseModel({
    required this.id,
    required this.savingId,
    required this.userId,
    required this.amount,
    required this.contributorName,
    required this.createdAt,
  });

  factory JointSavingResponseModel.fromJson(String str) =>
      JointSavingResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JointSavingResponseModel.fromMap(Map<String, dynamic> map) =>
      JointSavingResponseModel(
        id: map['id'],
        savingId: map['saving_id'],
        userId: map['user_id'],
        amount: map['amount'],
        contributorName: map['contributor_name'] ?? '',
        createdAt: map['created_at'],
      );

  Map<String, dynamic> toMap() => {
    "id": id,
    "saving_id": savingId,
    "user_id": userId,
    "amount": amount,
    "contributor_name": contributorName,
    "created_at": createdAt,
  };
}
