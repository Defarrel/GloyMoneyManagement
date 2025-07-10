import 'dart:convert';

class InvtRequestModel {
  final int savingId;
  final int senderId;
  final int receiverId;

  InvtRequestModel({
    required this.savingId,
    required this.senderId,
    required this.receiverId,
  });

  factory InvtRequestModel.fromJson(String str) =>
      InvtRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InvtRequestModel.fromMap(Map<String, dynamic> json) =>
      InvtRequestModel(
        savingId: json["saving_id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
      );

  Map<String, dynamic> toMap() => {
        "saving_id": savingId,
        "sender_id": senderId,
        "receiver_id": receiverId,
      };
}
