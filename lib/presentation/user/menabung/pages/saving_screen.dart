import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/savingScreen/saving_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/savingScreen/saving_event.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/savingScreen/saving_state.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/pages/detail_saving.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/pages/tambah_saving.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class SavingScreen extends StatelessWidget {
  const SavingScreen({super.key});

  String _formatRupiah(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          SavingBloc(SavingRepository(ServiceHttpClient()))
            ..add(LoadAllSavingEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F8),
        appBar: CustomAppBar(title: "Menabung", showLogo: true),
        body: BlocBuilder<SavingBloc, SavingState>(
          builder: (context, state) {
            if (state is SavingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SavingLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SavingBloc>().add(LoadAllSavingEvent());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final saving in state.savings)
                      GestureDetector(
                        onTap: () {
                          context.read<SavingBloc>().add(
                            LoadSavingDetailEvent(
                              id: saving.id,
                              onSuccess: (savingDetail) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailSaving(savingId: saving.id),
                                  ),
                                );
                              },
                              onError: (error) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(error)));
                              },
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                saving.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Terkumpul",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Rp ${_formatRupiah(saving.currentAmount)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          "Target",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Rp ${_formatRupiah(saving.targetAmount)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearProgressIndicator(
                                value:
                                    (saving.currentAmount / saving.targetAmount)
                                        .clamp(0.0, 1.0),
                                backgroundColor: Colors.grey[300],
                                color: AppColors.primary800,
                                minHeight: 8,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Deadline: ${_formatDate(saving.deadline)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else if (state is SavingError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Tidak ada data"));
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TambahSavingPage()),
            ).then((isSaved) {
              if (isSaved == true) {
                context.read<SavingBloc>().add(LoadAllSavingEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Tabungan berhasil ditambahkan"),
                  ),
                );
              }
            });
          },
          backgroundColor: AppColors.primary800,
          label: const Text(
            "Tambah Tabungan",
            style: TextStyle(color: Colors.white),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
