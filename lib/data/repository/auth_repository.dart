import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/data/models/request/auth/login_request_model.dart';
import 'package:gloymoneymanagement/data/models/request/auth/register_request_model.dart';
import 'package:gloymoneymanagement/data/models/response/auth/auth_response_mode.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final ServiceHttpClient _serviceHttpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthRepository(this._serviceHttpClient);

  // Login
  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel requestModel,
  ) async {
    try {
      final http.Response response = await _serviceHttpClient.post(
        "auth/login",
        requestModel.toMap(),
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromMap(jsonResponse);

        await _secureStorage.write(
          key: "authToken",
          value: authResponse.token ?? '',
        );
        await _secureStorage.write(
          key: "userRole",
          value: authResponse.user?.role ?? '',
        );

        log("Login success: ${authResponse.user?.email}");
        return Right(authResponse);
      } else {
        final message = jsonResponse['message'] ?? "Login failed";
        log("Login failed: $message");
        return Left(message);
      }
    } catch (e) {
      log("Login exception: $e");
      return Left("An error occurred while logging in.");
    }
  }

  // Register
  Future<Either<String, String>> register(
    RegisterRequestModel requestModel,
  ) async {
    try {
      final http.Response response = await _serviceHttpClient.post(
        "auth/register",
        requestModel.toMap(),
      );

      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        return Right(jsonResponse['message']);
      } else {
        return Left(jsonResponse['message'] ?? "Registration failed");
      }
    } catch (e) {
      log("Registration error: $e");
      return Left("An error occurred while registering.");
    }
  }

  // Logout
  Future<void> logout() async {
    await _secureStorage.delete(key: "authToken");
    await _secureStorage.delete(key: "userRole");
    log("Logged out");
  }
}
