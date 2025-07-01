import 'dart:convert';

class SavingResponseModel {
  final int id;
  final int userId;
  final String title;
  final int targetAmount;
  final int currentAmount;
  final String deadline;
  final String ownerName;

  SavingResponseModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.ownerName,
  });

  factory SavingResponseModel.fromJson(String str) =>
      SavingResponseModel.fromMap(json.decode(str));

  factory SavingResponseModel.fromMap(Map<String, dynamic> map) =>
      SavingResponseModel(
        id: map['id'],
        userId: map['user_id'],
        title: map['title'],
        targetAmount: map['target_amount'],
        currentAmount: map['current_amount'],
        deadline: map['deadline'],
        ownerName: map['owner_name'] ?? '',
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "target_amount": targetAmount,
        "current_amount": currentAmount,
        "deadline": deadline,
        "owner_name": ownerName,
      };
}
