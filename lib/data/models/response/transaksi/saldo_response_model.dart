import 'dart:convert';

class TransactionResponseModel {
  final int id;
  final int userId;
  final String type;
  final String? category;
  final double amount;
  final String? description;
  final String? location;
  final DateTime date;

  TransactionResponseModel({
    required this.id,
    required this.userId,
    required this.type,
    this.category,
    required this.amount,
    this.description,
    this.location,
    required this.date,
  });

  factory TransactionResponseModel.fromMap(Map<String, dynamic> json) =>
      TransactionResponseModel(
        id: json['id'],
        userId: json['user_id'],
        type: json['type'],
        category: json['category'],
        amount: (json['amount'] as num).toDouble(),
        description: json['description'],
        location: json['location'],
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "category": category,
        "amount": amount,
        "description": description,
        "location": location,
        "date": date.toIso8601String(),
      };

  static List<TransactionResponseModel> fromJsonList(String str) {
    final data = json.decode(str);
    return List<TransactionResponseModel>.from(
      data.map((item) => TransactionResponseModel.fromMap(item)),
    );
  }
}
