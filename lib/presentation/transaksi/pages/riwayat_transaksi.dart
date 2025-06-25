import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/data/models/response/transaksi/transaction_response_model.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:intl/intl.dart';

class RiwayatTransaksi extends StatefulWidget {
  const RiwayatTransaksi({super.key});

  @override
  State<RiwayatTransaksi> createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi> {
  late Future<List<TransactionResponseModel>> _futureTransactions;
  final TransactionRepository _repository = TransactionRepository(ServiceHttpClient());

  @override
  void initState() {
    super.initState();
    _futureTransactions = _loadTransactions();
  }

  Future<List<TransactionResponseModel>> _loadTransactions() async {
    final result = await _repository.getTransactions();
    return result.fold(
      (error) => throw Exception(error),
      (data) => data,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Transaksi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigasi ke halaman tambah transaksi
            },
          ),
        ],
      ),
      body: FutureBuilder<List<TransactionResponseModel>>(
        future: _futureTransactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada transaksi'));
          }

          final transaksi = snapshot.data!;
          return ListView.builder(
            itemCount: transaksi.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = transaksi[index];
              return _TransactionCard(item: item);
            },
          );
        },
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionResponseModel item;

  const _TransactionCard({required this.item});

  @override

  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(item.date);
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    final amountText = (item.type == 'pemasukan' ? '+ ' : '- ') + currencyFormat.format(item.amount);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.category ?? '-', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                if (item.location != null && item.location!.isNotEmpty)
                  Text(item.location!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(formattedDate, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              amountText,
              style: TextStyle(
                color: item.type == 'pemasukan' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
