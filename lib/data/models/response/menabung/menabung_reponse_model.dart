import 'dart:convert';

class SavingResponseModel {
  final int id;
  final int userId;
  final String title;
  final int targetAmount;
  final int currentAmount;
  final String deadline;
  final String ownerName;
  final List<MemberModel> members;

  SavingResponseModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.ownerName,
    required this.members,
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
        members: map['members'] != null
            ? List<MemberModel>.from(
                (map['members'] as List<dynamic>).map(
                  (x) => MemberModel.fromMap(x),
                ),
              )
            : [],
      );
}

class MemberModel {
  final int id;
  final String name;
  final int amount;

  MemberModel({required this.id, required this.name, required this.amount});

  factory MemberModel.fromMap(Map<String, dynamic> map) => MemberModel(
    id: int.parse(map['id'].toString()),
    name: map['name'],
    amount: double.tryParse(map['amount'].toString())?.toInt() ?? 0,
  );

  Map<String, dynamic> toMap() => {"id": id, "name": name, "amount": amount};
}
