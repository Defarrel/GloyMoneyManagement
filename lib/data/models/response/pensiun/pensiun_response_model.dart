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
        id: _parseToInt(map["id"]),
        userId: _parseToInt(map["user_id"]),
        title: map["title"],
        targetAmount: _parseToInt(map["target_amount"]),
        currentAmount: _parseToInt(map["current_amount"]),
        description: map["description"],
        deadline: DateTime.parse(map["deadline"]),
      );

  static int _parseToInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value.split(".")[0]) ?? 0;
    return 0;
  }

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
