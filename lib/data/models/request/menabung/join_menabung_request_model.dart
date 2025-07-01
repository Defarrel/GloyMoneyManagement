import 'dart:convert';

class JointSavingRequestModel {
  final int userId;
  final int amount;

  JointSavingRequestModel({required this.userId, required this.amount});

  factory JointSavingRequestModel.fromJson(String str) =>
      JointSavingRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JointSavingRequestModel.fromMap(Map<String, dynamic> map) =>
      JointSavingRequestModel(userId: map['user_id'], amount: map['amount']);

  Map<String, dynamic> toMap() => {"user_id": userId, "amount": amount};
}
