import 'dart:convert';

class AddPensionRequestModel {
  final int targetAmount;
  final String deadline;

  AddPensionRequestModel({
    required this.targetAmount,
    required this.deadline,
  });

  factory AddPensionRequestModel.fromJson(String str) =>
      AddPensionRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AddPensionRequestModel.fromMap(Map<String, dynamic> map) =>
      AddPensionRequestModel(
        targetAmount: map['target_amount'],
        deadline: map['deadline'],
      );

  Map<String, dynamic> toMap() => {
        "target_amount": targetAmount,
        "deadline": deadline,
      };
}
