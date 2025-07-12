import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/core.dart';
import 'package:gloymoneymanagement/data/models/response/transaksi/transaction_response_model.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/bloc/detailTransaksi/detail_transaksi_bloc.dart';
import 'package:intl/intl.dart';

class DetailTransaksi extends StatelessWidget {
  final TransactionResponseModel transaksi;

  const DetailTransaksi({super.key, required this.transaksi});

  String _formatRupiah(double value) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormat.format(value);
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Transaksi"),
        content: const Text("Apakah Anda yakin ingin menghapus transaksi ini?"),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      context.read<DetailTransaksiBloc>().add(DeleteTransactionRequested(transaksi.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(transaksi.date);

    return BlocConsumer<DetailTransaksiBloc, DetailTransaksiState>(
      listener: (context, state) {
        if (state is DetailTransaksiDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Transaksi berhasil dihapus")),
          );
          Navigator.pop(context, true);
        } else if (state is DetailTransaksiError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal menghapus: ${state.message}")),
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: CustomAppBar(
                title: "Detail Transaksi",
                showLogo: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmDelete(context),
                  ),
                ],
              ),
              body: Container(
                color: AppColors.background,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Kategori", style: TextStyle(color: Colors.grey[700])),
                              Text(
                                transaksi.category ?? "-",
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Text("Nominal", style: TextStyle(color: Colors.grey[700])),
                              Text(
                                _formatRupiah(transaksi.amount),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: transaksi.type == "pemasukan" ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text("Jenis", style: TextStyle(color: Colors.grey[700])),
                              Text(transaksi.type, style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 16),
                              if (transaksi.description?.isNotEmpty ?? false) ...[
                                Text("Deskripsi", style: TextStyle(color: Colors.grey[700])),
                                Text(transaksi.description!, style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 16),
                              ],
                              if (transaksi.location?.isNotEmpty ?? false) ...[
                                Text("Lokasi", style: TextStyle(color: Colors.grey[700])),
                                Text(transaksi.location!, style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 16),
                              ],
                              Text("Tanggal", style: TextStyle(color: Colors.grey[700])),
                              Text(formattedDate, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state is DetailTransaksiLoading)
              Container(
                color: Colors.black.withOpacity(0.1),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
