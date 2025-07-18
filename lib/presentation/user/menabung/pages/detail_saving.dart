import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/savingDetail/saving_detail_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/savingDetail/saving_detail_event.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/savingDetail/saving_detail_state.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/pages/invt_saving.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/pages/riwayat_saving.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/pages/top_up_saving.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/pages/withdraw_saving.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class DetailSaving extends StatefulWidget {
  final int savingId;

  const DetailSaving({super.key, required this.savingId});

  @override
  State<DetailSaving> createState() => _DetailSavingState();
}

class _DetailSavingState extends State<DetailSaving> {
  late SavingDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SavingDetailBloc(SavingRepository(ServiceHttpClient()));
    _bloc.add(LoadSavingDetailEvent(widget.savingId));
  }

  String _formatRupiah(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (m) => '.',
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.tryParse(dateStr);
    if (date == null) return dateStr;
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F8),
        appBar: CustomAppBar(title: "Detail Tabungan", showLogo: false),
        body: BlocBuilder<SavingDetailBloc, SavingDetailState>(
          builder: (context, state) {
            if (state is SavingDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SavingDetailError) {
              return Center(child: Text("Gagal memuat: ${state.message}"));
            } else if (state is SavingDetailLoaded) {
              final saving = state.saving;
              final double progress =
                  saving.currentAmount / saving.targetAmount;
              final percentage = (progress * 100).clamp(0, 100).toInt();

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.primary100,
                          child: Icon(Icons.group, color: AppColors.primary800),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tabungan Bersama",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Pantau dan kelola tabungan bersama teman, pasangan atau keluarga",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: CircularPercentIndicator(
                        radius: 100,
                        lineWidth: 14,
                        percent: progress.clamp(0, 1),
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor: Colors.grey[300]!,
                        progressColor: AppColors.primary800,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "$percentage%",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Tercapai",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Detail Tabungan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                  'Apakah kamu yakin ingin menghapus tabungan ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              print(
                                '✅ Konfirmasi hapus tabungan ID: ${saving.id}',
                              );
                              try {
                                await SavingRepository(
                                  ServiceHttpClient(),
                                ).deleteSaving(saving.id);
                                print(
                                  '✅ Tabungan berhasil dihapus dari server',
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Tabungan berhasil dihapus",
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                print('❌ Gagal menghapus tabungan: $e');
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Gagal menghapus: $e"),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _infoRow("Judul", saving.title),
                    _infoRow(
                      "Target",
                      "Rp ${_formatRupiah(saving.targetAmount)}",
                    ),
                    _infoRow(
                      "Terkumpul",
                      "Rp ${_formatRupiah(saving.currentAmount)}",
                    ),
                    _infoRow("Deadline", _formatDate(saving.deadline)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Anggota Tabungan",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => InvtSaving(savingId: saving.id),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.primary800),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                          ),
                          child: Text(
                            "Undang",
                            style: TextStyle(color: AppColors.primary800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...saving.members.map(
                      (member) => ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.primary100,
                          child: Icon(
                            Icons.person,
                            color: AppColors.primary800,
                          ),
                        ),
                        title: Text(member.name),
                        subtitle: Text("Rp ${_formatRupiah(member.amount)}"),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 164, 164, 164),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _menuButton(
                            icon: Icons.add_circle_outline,
                            label: "Menabung",
                            color: AppColors.primary,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => TopUpSaving(
                                    savingId: saving.id,
                                    userId: saving.userId,
                                  ),
                                ),
                              );
                            },
                          ),
                          _menuButton(
                            icon: Icons.outbox_rounded,
                            label: "Tarik",
                            color: AppColors.primary,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => WithdrawSaving(
                                    savingId: saving.id,
                                    userId: saving.userId,
                                  ),
                                ),
                              );
                            },
                          ),
                          _menuButton(
                            icon: Icons.history,
                            label: "Riwayat",
                            color: AppColors.primary,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RiwayatSaving(savingId: saving.id),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuButton({
    required IconData icon,
    required String label,
    required Color color,
    Color iconColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
