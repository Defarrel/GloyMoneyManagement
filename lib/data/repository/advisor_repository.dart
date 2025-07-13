import 'dart:convert';
import 'package:gloymoneymanagement/data/models/response/advisor/advisor_response_model.dart';
import 'package:gloymoneymanagement/data/models/request/advisor/advisor_request_model.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class AdvisorRepository {
  final ServiceHttpClient _serviceHttpClient;

  AdvisorRepository(this._serviceHttpClient);

  /// Kirim request akses ke user (PENDING)
  Future<void> requestAccess(int userId) async {
    final body = AdvisorRequest(
      id: 0,
      userId: userId,
      status: 'PENDING',
      feedback: null,
    ).toMap();

    final res = await _serviceHttpClient.postWithToken(
      'advisor_requests/request',
      body,
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      if (data['status'] == 'PENDING') {
        return;
      } else {
        throw Exception('Unexpected status: ${data['status']}');
      }
    } else {
      throw Exception('Gagal minta akses: ${res.body}');
    }
  }

  /// Ambil semua request advisor sekarang
  Future<List<AdvisorResponseModel>> getMyRequests() async {
    final res = await _serviceHttpClient.get('advisor_requests');
    if (res.statusCode == 200) {
      final List<dynamic> list = json.decode(res.body);
      return list
          .map((e) => AdvisorResponseModel.fromMap(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Gagal fetch requests: ${res.body}');
  }

  /// Update feedback atau status (ACCEPTED/DECLINED)
  Future<AdvisorResponseModel> sendFeedbackOrStatus({
    required int requestId,
    String? feedback,
    String? status,
  }) async {
    final body = <String, dynamic>{};
    if (feedback != null) body['feedback'] = feedback;
    if (status != null) body['status'] = status;

    final res = await _serviceHttpClient.put(
      'advisor_requests/$requestId',
      body,
    );

    if (res.statusCode == 200) {
      return AdvisorResponseModel.fromJson(res.body);
    }
    throw Exception('Gagal update request: ${res.body}');
  }

  /// Merespons request advisor (ACCEPTED/DECLINED)
  Future<String> respondToAdvisorRequest({
    required int requestId,
    required String status,
  }) async {
    final res = await _serviceHttpClient.put('advisor_requests/$requestId', {
      'status': status,
    });

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return data['message'] ?? 'Berhasil memperbarui status';
    } else {
      throw Exception('Gagal merespons request: ${res.body}');
    }
  }
}
