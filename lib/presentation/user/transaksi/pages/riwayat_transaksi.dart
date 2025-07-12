import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/data/models/response/transaksi/transaction_response_model.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/bloc/riwayatTransaksi/riwayat_transaksi_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/detail_transaksi.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/tambah_transaksi.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:intl/intl.dart';

class RiwayatTransaksi extends StatelessWidget {
  const RiwayatTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RiwayatTransaksiBloc(
        repository: TransactionRepository(ServiceHttpClient()),
      )..add(LoadRiwayatTransaksi()),
      child: const _RiwayatTransaksiView(),
    );
  }
}

class _RiwayatTransaksiView extends StatelessWidget {
  const _RiwayatTransaksiView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Riwayat Transaksi",
        showLogo: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahTransaksi()),
              ).then((value) {
                if (value == true) {
                  context.read<RiwayatTransaksiBloc>().add(
                    LoadRiwayatTransaksi(),
                  );
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<RiwayatTransaksiBloc, RiwayatTransaksiState>(
        builder: (context, state) {
          if (state is RiwayatTransaksiLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RiwayatTransaksiError) {
            return Center(child: Text('Gagal memuat data: ${state.message}'));
          } else if (state is RiwayatTransaksiLoaded) {
            final transaksi = state.transactions;

            if (transaksi.isEmpty) {
              return const Center(child: Text('Tidak ada transaksi'));
            }

            return ListView.builder(
              itemCount: transaksi.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = transaksi[index];
                return _TransactionCard(item: item);
              },
            );
          }

          return const SizedBox();
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
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final amountText =
        (item.type == 'pemasukan' ? '+ ' : '- ') +
        currencyFormat.format(item.amount);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailTransaksi(transaksi: item)),
        ).then((refresh) {
          if (refresh == true) {
            context.read<RiwayatTransaksiBloc>().add(LoadRiwayatTransaksi());
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 9),
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
                  Text(
                    item.category ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  if (item.location != null && item.location!.isNotEmpty)
                    Text(
                      item.location!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
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
      ),
    );
  }
}
