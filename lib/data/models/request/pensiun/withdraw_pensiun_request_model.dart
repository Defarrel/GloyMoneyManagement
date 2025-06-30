import 'dart:convert';

class WithdrawPensionRequestModel {
  final int amount;

  WithdrawPensionRequestModel({required this.amount});

  factory WithdrawPensionRequestModel.fromJson(String str) =>
      WithdrawPensionRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WithdrawPensionRequestModel.fromMap(Map<String, dynamic> map) =>
      WithdrawPensionRequestModel(amount: map['amount']);

  Map<String, dynamic> toMap() => {
        "amount": amount,
      };
}
