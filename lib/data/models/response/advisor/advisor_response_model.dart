import 'dart:convert';

class AdvisorResponseModel {
  final int id;
  final int advisorId;
  final int userId;
  final String status;
  final String? feedback;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdvisorResponseModel({
    required this.id,
    required this.advisorId,
    required this.userId,
    required this.status,
    this.feedback,
    this.createdAt,
    this.updatedAt,
  });

  factory AdvisorResponseModel.fromMap(Map<String, dynamic> map) {
    return AdvisorResponseModel(
      id: map['id'] as int,
      advisorId: map['advisor_id'] as int,
      userId: map['user_id'] as int,
      status: map['status'] as String,
      feedback: map['feedback'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
    );
  }

  factory AdvisorResponseModel.fromJson(String source) =>
      AdvisorResponseModel.fromMap(json.decode(source));

  Map<String, dynamic> toMap() => {
    'id': id,
    'advisor_id': advisorId,
    'user_id': userId,
    'status': status,
    'feedback': feedback,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  String toJson() => json.encode(toMap());
}
