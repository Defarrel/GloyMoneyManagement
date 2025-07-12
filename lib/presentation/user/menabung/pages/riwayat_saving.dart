import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/response/menabung/join_menabung_response_model.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/riwayat_saving/riwayat_saving_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/riwayat_saving/riwayat_saving_event.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/riwayat_saving/riwayat_saving_state.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:intl/intl.dart';

class RiwayatSaving extends StatefulWidget {
  final int savingId;
  const RiwayatSaving({super.key, required this.savingId});

  @override
  State<RiwayatSaving> createState() => _RiwayatSavingState();
}

class _RiwayatSavingState extends State<RiwayatSaving> {
  late final RiwayatSavingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = RiwayatSavingBloc(SavingRepository(ServiceHttpClient()));
    _bloc.add(LoadRiwayatSaving(widget.savingId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: const CustomAppBar(title: "Riwayat Tabungan", showLogo: false),
        backgroundColor: const Color(0xFFF4F6F8),
        body: BlocBuilder<RiwayatSavingBloc, RiwayatSavingState>(
          builder: (context, state) {
            if (state is RiwayatSavingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RiwayatSavingFailure) {
              return Center(child: Text("Gagal: ${state.message}"));
            } else if (state is RiwayatSavingLoaded) {
              if (state.data.isEmpty) {
                return const Center(child: Text("Belum ada kontribusi"));
              }
              return ListView.builder(
                itemCount: state.data.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final item = state.data[index];
                  return _buildItem(item);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildItem(JointSavingResponseModel item) {
    final nominal = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(item.amount);

    final createdAt = DateTime.tryParse(item.createdAt);
    final tanggal = createdAt != null
        ? DateFormat('dd MMM yyyy – HH:mm', 'id_ID').format(createdAt)
        : item.createdAt;

    final contributorName = (item.userName?.isNotEmpty == true)
        ? item.userName!
        : (item.contributorName?.isNotEmpty == true
              ? item.contributorName!
              : "-");

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                contributorName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                nominal,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            tanggal,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
