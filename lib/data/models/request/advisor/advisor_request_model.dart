import 'dart:convert';

class AdvisorRequest {
  final int id;
  final int userId;
  final String status;
  final String? feedback;

  AdvisorRequest({
    required this.id,
    required this.userId,
    required this.status,
    this.feedback,
  });

  factory AdvisorRequest.fromMap(Map<String, dynamic> map) {
    return AdvisorRequest(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      status: map['status'] as String,
      feedback: map['feedback'] as String?,
    );
  }

  factory AdvisorRequest.fromJson(String str) =>
      AdvisorRequest.fromMap(json.decode(str) as Map<String, dynamic>);

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    final m = <String, dynamic>{
      'user_id': userId,
      'status': status,
      'feedback': feedback,
    };
    return m;
  }
}
