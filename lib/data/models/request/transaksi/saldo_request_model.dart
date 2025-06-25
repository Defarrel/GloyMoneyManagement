import 'dart:convert';

class TransactionRequestModel {
  final String type;       // income / expense
  final String? category;
  final double amount;
  final String? description;
  final String? location;
  final DateTime? date;

  TransactionRequestModel({
    required this.type,
    this.category,
    required this.amount,
    this.description,
    this.location,
    this.date,
  });

  Map<String, dynamic> toMap() => {
        "type": type,
        "category": category,
        "amount": amount,
        "description": description,
        "location": location,
        "date": date?.toIso8601String(),
      };

  String toJson() => json.encode(toMap());
}
