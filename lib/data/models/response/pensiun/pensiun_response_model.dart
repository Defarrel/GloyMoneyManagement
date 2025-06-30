import 'dart:convert';

class PensionResponseModel {
  final int id;
  final int userId;
  final String title;
  final int targetAmount;
  final int currentAmount;
  final String description;
  final DateTime deadline;

  PensionResponseModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.description,
    required this.deadline,
  });

  factory PensionResponseModel.fromJson(String str) =>
      PensionResponseModel.fromMap(json.decode(str));

  factory PensionResponseModel.fromMap(Map<String, dynamic> map) =>
      PensionResponseModel(
        id: map["id"],
        userId: map["user_id"],
        title: map["title"],
        targetAmount: map["target_amount"],
        currentAmount: map["current_amount"],
        description: map["description"],
        deadline: DateTime.parse(map["deadline"]),
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "title": title,
        "target_amount": targetAmount,
        "current_amount": currentAmount,
        "description": description,
        "deadline": deadline.toIso8601String(),
      };
}
