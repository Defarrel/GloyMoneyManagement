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

  Future<Either<String, AkunResponseModel>> getCurrentUser() async {
    try {
      final response = await _serviceHttpClient.get('me');

      if (response.statusCode == 200) {
        return Right(AkunResponseModel.fromJson(response.body));
      } else {
        final message = _parseMessage(response.body);
        return Left(message);
      }
    } catch (e) {
      log("Exception in getCurrentUser: $e");
      return Left('Gagal memuat data');
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

  // Ubah password
  Future<Either<String, String>> updatePassword(
    int userId,
    String newPassword,
  ) async {
    try {
      log("Updating password for user ID: $userId");

      final response = await _serviceHttpClient.put("users/$userId/password", {
        "password": newPassword,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final message = body['message'] ?? "Password berhasil diubah";
        return Right(message);
      } else {
        final message = _parseMessage(response.body);
        log("Failed to update password: $message");
        return Left(message);
      }
    } catch (e) {
      log("Exception during updatePassword: $e");
      return const Left("Gagal mengubah password.");
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

  Future<Either<String, String>> uploadProfilePhoto(
    int userId,
    String filePath,
  ) async {
    try {
      final token = await _secureStorage.read(key: "authToken");
      final baseUrl = _serviceHttpClient.baseUrl.replaceAll(
        '/api/',
        '',
      ); // Remove /api if needed

      final uri = Uri.parse('$baseUrl/api/users/$userId/photo');

      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('photo', filePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        final resBody = await response.stream.bytesToString();
        final url = jsonDecode(resBody)['photo_profile'];
        return Right(url);
      } else {
        return const Left("Gagal upload foto");
      }
    } catch (e) {
      return Left("Error: $e");
    }
  }
}
