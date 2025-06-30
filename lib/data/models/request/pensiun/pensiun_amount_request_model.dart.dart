import 'dart:convert';

class PensiunAmountRequestModel {
  final int amount;

  PensiunAmountRequestModel({required this.amount});

  factory PensiunAmountRequestModel.fromJson(String str) =>
      PensiunAmountRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PensiunAmountRequestModel.fromMap(Map<String, dynamic> map) =>
      PensiunAmountRequestModel(amount: map['amount']);

  Map<String, dynamic> toMap() => {
        "amount": amount,
      };
}
