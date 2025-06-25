import 'dart:convert';

class TransactionRequestModel {
  final String type;
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

  factory TransactionRequestModel.fromJson(String str) =>
      TransactionRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TransactionRequestModel.fromMap(Map<String, dynamic> json) =>
      TransactionRequestModel(
        type: json['type'],
        category: json['category'],
        amount: (json['amount'] as num).toDouble(),
        description: json['description'],
        location: json['location'],
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "category": category,
        "amount": amount,
        "description": description,
        "location": location,
        "date": date?.toIso8601String(),
      };
}
