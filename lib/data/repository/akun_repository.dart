import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/data/models/request/akun/akun_request_model.dart';
import 'package:gloymoneymanagement/data/models/response/akun/akun_response_model.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class AkunRepository {
  final ServiceHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AkunRepository(this._serviceHttpClient);

  /// Ambil data akun berdasarkan ID
  Future<Either<String, AkunResponseModel>> getAkunById(int id) async {
    try {
      log("Fetching user with ID: $id");
      final http.Response response = await _serviceHttpClient.get("users/$id");

      if (response.statusCode == 200) {
        final data = AkunResponseModel.fromJson(response.body);
        log("User data fetched: ${data.name}");
        return Right(data);
      } else {
        final message = _parseMessage(response.body);
        log("Failed to fetch user: $message");
        return Left(message);
      }
    } catch (e) {
      log("Exception during getAkunById: $e");
      return const Left("Terjadi kesalahan saat mengambil data akun.");
    }
  }

  /// Ambil semua user (untuk fitur undang teman)
  Future<Either<String, List<AkunResponseModel>>> getAllUsers() async {
    try {
      final response = await _serviceHttpClient.get("users");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        final users = jsonList
            .map((userJson) => AkunResponseModel.fromMap(userJson))
            .toList();

        log("Fetched ${users.length} users.");
        return Right(users);
      } else {
        final message = _parseMessage(response.body);
        log("Failed to fetch users: $message");
        return Left(message);
      }
    } catch (e) {
      log("Exception during getAllUsers: $e");
      return const Left("Terjadi kesalahan saat mengambil daftar pengguna.");
    }
  }

  /// Update data akun
  Future<Either<String, AkunResponseModel>> updateAkun(
    int id,
    AkunRequestModel model,
  ) async {
    try {
      log("Updating user ID $id with data: ${model.toMap()}");
      final response = await _serviceHttpClient.put("users/$id", model.toMap());

      if (response.statusCode == 200) {
        final data = AkunResponseModel.fromJson(response.body);
        log("User updated successfully: ${data.name}");
        return Right(data);
      } else {
        final message = _parseMessage(response.body);
        log("Failed to update user: $message");
        return Left(message);
      }
    } catch (e) {
      log("Exception during updateAkun: $e");
      return const Left("Gagal memperbarui akun.");
    }
  }

  /// Hapus akun user
  Future<Either<String, bool>> deleteAkun(int id) async {
    try {
      log("Deleting user ID: $id");
      final response = await _serviceHttpClient.delete("users/$id");

      if (response.statusCode == 200) {
        log("User deleted successfully.");
        return const Right(true);
      } else {
        final message = _parseMessage(response.body);
        log("Failed to delete user: $message");
        return Left(message);
      }
    } catch (e) {
      log("Exception during deleteAkun: $e");
      return const Left("Gagal menghapus akun.");
    }
  }

  /// Ambil ID user dari secure storage
  Future<int?> getUserIdFromStorage() async {
    final idStr = await _secureStorage.read(key: 'userId');
    return idStr != null ? int.tryParse(idStr) : null;
  }

  /// Ambil role user dari secure storage
  Future<String?> getRoleFromStorage() async {
    return await _secureStorage.read(key: 'userRole');
  }

  /// Parsing pesan error dari response
  String _parseMessage(String responseBody) {
    try {
      final data = responseBody.isNotEmpty ? jsonDecode(responseBody) : {};
      return data['message'] ?? 'Unknown error';
    } catch (_) {
      return 'Unknown error';
    }
  }
}
