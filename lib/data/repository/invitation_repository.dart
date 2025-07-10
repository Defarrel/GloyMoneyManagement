import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/data/models/request/invite/invt_request_model.dart';
import 'package:gloymoneymanagement/data/models/response/invite/invt_response_model.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class InvitationRepository {
  final ServiceHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  InvitationRepository(this._serviceHttpClient);

  // Kirim Undangan
  Future<Either<String, String>> sendInvitation(
    InvtRequestModel requestModel,
  ) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "invitations/invite",
        requestModel.toMap(),
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        log("Undangan berhasil dikirim");
        return Right(jsonResponse['message']);
      } else {
        log("Gagal kirim undangan: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Gagal mengirim undangan");
      }
    } catch (e) {
      log("Exception kirim undangan: $e");
      return Left("Terjadi kesalahan saat mengirim undangan");
    }
  }

  // Ambil Notifikasi Undangan
  Future<Either<String, List<InvtResponseModel>>> getUserInvitations() async {
    try {
      final userId = await _secureStorage.read(key: "userId");
      if (userId == null) return Left("User ID tidak ditemukan");

      final response = await _serviceHttpClient.get(
        "invitations/notifications/$userId",
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> list = jsonResponse;
        final result = list.map((e) => InvtResponseModel.fromMap(e)).toList();
        log("${result.length} notifikasi diambil");
        return Right(result);
      } else {
        log("Gagal ambil notifikasi: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Gagal mengambil notifikasi");
      }
    } catch (e) {
      log("Exception ambil notifikasi: $e");
      return Left("Terjadi kesalahan saat mengambil notifikasi");
    }
  }

  // Tanggapi Undangan
  Future<Either<String, String>> respondToInvitation({
    required int invitationId,
    required String status,
  }) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "invitations/respond",
        {"invitation_id": invitationId, "status": status},
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        log("Undangan di-$status");
        return Right(jsonResponse['message']);
      } else {
        log("Gagal tanggapi: ${jsonResponse['message']}");
        return Left(jsonResponse['message'] ?? "Gagal memproses undangan");
      }
    } catch (e) {
      log("Exception tanggapi undangan: $e");
      return Left("Terjadi kesalahan saat memproses undangan");
    }
  }
}
