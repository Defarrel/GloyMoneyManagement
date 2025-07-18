import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/data/models/request/menabung/join_menabung_request_model.dart';
import 'package:gloymoneymanagement/data/models/request/menabung/menabung_request_model.dart';
import 'package:gloymoneymanagement/data/models/response/menabung/join_menabung_response_model.dart';
import 'package:gloymoneymanagement/data/models/response/menabung/menabung_reponse_model.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class SavingRepository {
  final ServiceHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  SavingRepository(this._serviceHttpClient);

  /// GET all savings
  Future<Either<String, List<SavingResponseModel>>> getAllSavings() async {
    try {
      final userId = await _secureStorage.read(key: "userId");
      if (userId == null) return Left("User ID tidak ditemukan");

      final response = await _serviceHttpClient.get("savings/user/$userId");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final data = jsonList
            .map((json) => SavingResponseModel.fromMap(json))
            .toList();
        return Right(data);
      } else {
        final error = jsonDecode(response.body);
        return Left(error['message'] ?? 'Gagal memuat tabungan');
      }
    } catch (e) {
      log("Error getAllSavings: $e");
      return Left("Terjadi kesalahan saat mengambil tabungan");
    }
  }

  /// GET saving detail by ID
  Future<Either<String, SavingResponseModel>> getSavingDetail(int id) async {
    try {
      final http.Response res = await _serviceHttpClient.get('savings/$id');

      final data = SavingResponseModel.fromJson(res.body);
      return Right(data);
    } catch (e) {
      log("getSavingDetail error: $e");
      return const Left("Gagal memuat detail tabungan");
    }
  }

  /// POST create new saving
  Future<Either<String, String>> createSaving(SavingRequestModel model) async {
    try {
      final response = await _serviceHttpClient.postWithToken(
        "savings",
        model.toMap(),
      );
      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(data['message'] ?? "Tabungan berhasil dibuat");
      } else {
        return Left(data['message'] ?? "Gagal menambahkan tabungan");
      }
    } catch (e) {
      return Left("Terjadi kesalahan: $e");
    }
  }

  /// PUT top-up contribution to joint saving
  Future<Either<String, String>> contributeToSaving(
    int savingId,
    JointSavingRequestModel request,
  ) async {
    try {
      final http.Response res = await _serviceHttpClient.postWithToken(
        'savings/$savingId/contribute',
        request.toMap(),
      );
      final data = json.decode(res.body);
      return Right(data['message']);
    } catch (e) {
      log("contributeToSaving error: $e");
      return const Left("Gagal menabung ke tabungan bersama");
    }
  }

  /// POST withdraw from joint saving
  Future<Either<String, String>> withdrawFromSaving(
    int savingId,
    JointSavingRequestModel request,
  ) async {
    try {
      final http.Response res = await _serviceHttpClient.postWithToken(
        'savings/$savingId/withdraw',
        request.toMap(),
      );
      final data = json.decode(res.body);
      return Right(data['message']);
    } catch (e) {
      log("withdrawFromSaving error: $e");
      return const Left("Gagal menarik dana dari tabungan bersama");
    }
  }

  /// GET contributions history
  Future<Either<String, List<JointSavingResponseModel>>> getContributions(
    int savingId,
  ) async {
    try {
      final http.Response res = await _serviceHttpClient.get(
        'savings/$savingId/contributions',
      );
      final List<dynamic> jsonList = json.decode(res.body);

      final contributions = jsonList
          .map((e) => JointSavingResponseModel.fromMap(e))
          .toList();

      return Right(contributions);
    } catch (e) {
      log("getContributions error: $e");
      return const Left("Gagal mengambil riwayat menabung");
    }
  }

  Future<void> deleteSaving(int id) async {
    final res = await _serviceHttpClient.delete('savings/delete/$id');
    if (res.statusCode != 200) {
      throw Exception('Gagal menghapus tabungan: ${res.body}');
    }
  }
}
