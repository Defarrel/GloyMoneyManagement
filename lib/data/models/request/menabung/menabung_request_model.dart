import 'dart:convert';

class SavingRequestModel {
  final int userId;
  final String title;
  final int targetAmount;
  final String deadline;

  SavingRequestModel({
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.deadline,
  });

  factory SavingRequestModel.fromJson(String str) =>
      SavingRequestModel.fromMap(json.decode(str));

  factory SavingRequestModel.fromMap(Map<String, dynamic> map) =>
      SavingRequestModel(
        userId: map['user_id'],
        title: map['title'],
        targetAmount: map['target_amount'],
        deadline: map['deadline'],
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "title": title,
        "target_amount": targetAmount,
        "deadline": deadline,
      };
}
