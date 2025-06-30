import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/data/models/request/pensiun/pensiun_request_model.dart';
import 'package:gloymoneymanagement/data/models/request/pensiun/pensiun_amount_request_model.dart.dart';
import 'package:gloymoneymanagement/data/models/response/pensiun/pensiun_response_model.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class PensionRepository {
  final ServiceHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  PensionRepository(this._serviceHttpClient);

  Future<Either<String, PensionResponseModel>> getPension() async {
    try {
      final http.Response response = await _serviceHttpClient.get('pensiun');
      final jsonRes = json.decode(response.body);

      if (response.statusCode == 200) {
        return Right(PensionResponseModel.fromMap(jsonRes));
      } else {
        return Left(jsonRes['message'] ?? 'Gagal mengambil dana pensiun');
      }
    } catch (e) {
      log('Get pension error: $e');
      return Left('Terjadi kesalahan saat mengambil dana pensiun');
    }
  }

  Future<Either<String, String>> addPension(
    AddPensionRequestModel model,
  ) async {
    try {
      final http.Response response = await _serviceHttpClient.postWithToken(
        'pensiun/add',
        model.toMap(),
      );
      final jsonRes = json.decode(response.body);

      if (response.statusCode == 201) {
        return Right(jsonRes['message']);
      } else {
        return Left(jsonRes['message'] ?? 'Gagal menambah dana pensiun');
      }
    } catch (e) {
      log('Add pension error: $e');
      return Left('Terjadi kesalahan saat menambah dana pensiun');
    }
  }

  Future<Either<String, String>> withdrawPension(
    PensiunAmountRequestModel model,
  ) async {
    try {
      final http.Response response = await _serviceHttpClient.postWithToken(
        'pensiun/withdraw',
        model.toMap(),
      );
      final jsonRes = json.decode(response.body);

      if (response.statusCode == 200) {
        return Right(jsonRes['message']);
      } else {
        return Left(jsonRes['message'] ?? 'Gagal menarik dana pensiun');
      }
    } catch (e) {
      log('Withdraw pension error: $e');
      return Left('Terjadi kesalahan saat menarik dana pensiun');
    }
  }

  Future<Either<String, String>> topUpPension(
    PensiunAmountRequestModel model,
  ) async {
    try {
      final http.Response response = await _serviceHttpClient.postWithToken(
        'pensiun/topup', 
        model.toMap(),
      );
      final jsonRes = json.decode(response.body);

      if (response.statusCode == 200) {
        return Right(jsonRes['message']);
      } else {
        return Left(jsonRes['message'] ?? 'Gagal top up dana pensiun');
      }
    } catch (e) {
      log('Top up pension error: $e');
      return Left('Terjadi kesalahan saat top up dana pensiun');
    }
  }
}
