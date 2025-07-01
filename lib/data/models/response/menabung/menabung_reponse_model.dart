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
        id: int.parse(map['id'].toString()),
        userId: int.parse(map['user_id'].toString()),
        title: map['title'],
        targetAmount:
            double.tryParse(map['target_amount'].toString())?.toInt() ?? 0,
        currentAmount:
            double.tryParse(map['current_amount'].toString())?.toInt() ?? 0,
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
