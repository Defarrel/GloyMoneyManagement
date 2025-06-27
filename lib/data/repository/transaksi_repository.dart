import 'dart:convert';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/data/models/request/transaksi/transaction_request_model.dart';
import 'package:gloymoneymanagement/data/models/response/transaksi/transaction_response_model.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:http/http.dart' as http;

class TransactionRepository {
  final ServiceHttpClient _httpClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  TransactionRepository(this._httpClient);

  /// Tambah transaksi baru
  Future<Either<String, bool>> addTransaction(TransactionRequestModel model) async {
    try {
      log("Sending add transaction request: ${model.toMap()}");
      final http.Response response = await _httpClient.postWithToken("transactions", model.toMap());

      if (response.statusCode == 201) {
        log("Transaction added successfully.");
        return const Right(true);
      } else {
        final message = _parseMessage(response.body);
        log("Failed to add transaction: $message");
        return Left(message);
      }
    } catch (e) {
      log("Exception during addTransaction: $e");
      return const Left("Terjadi kesalahan saat menambahkan transaksi.");
    }
  }

  /// Ambil semua transaksi untuk user
  Future<Either<String, List<TransactionResponseModel>>> getTransactions() async {
    try {
      log("Fetching transactions...");
      final response = await _httpClient.get("transactions");

      if (response.statusCode == 200) {
        final transactions = TransactionResponseModel.fromJsonList(response.body);
        log("Fetched ${transactions.length} transactions.");
        return Right(transactions);
      } else {
        final message = _parseMessage(response.body);
        log("Failed to fetch transactions: $message");
        return Left(message);
      }
    } catch (e) {
      log("Exception during getTransactions: $e");
      return const Left("Terjadi kesalahan saat mengambil transaksi.");
    }
  }

  /// Fungsi tambahan: hapus transaksi
  Future<Either<String, bool>> deleteTransaction(int id) async {
    try {
      log("Deleting transaction with ID: $id");
      final response = await _httpClient.delete("transactions/$id");

      if (response.statusCode == 200) {
        log("Transaction deleted successfully.");
        return const Right(true);
      } else {
        final message = _parseMessage(response.body);
        log("Failed to delete transaction: $message");
        return Left(message);
      }
    } catch (e) {
      log("Exception during deleteTransaction: $e");
      return const Left("Gagal menghapus transaksi.");
    }
  }

  String _parseMessage(String responseBody) {
    try {
      final data = responseBody.isNotEmpty ? jsonDecode(responseBody) : {};
      return data['message'] ?? 'Unknown error';
    } catch (_) {
      return 'Unknown error';
    }
  }
}
