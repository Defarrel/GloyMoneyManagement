import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/bloc/main_pensiun/mainpensiun_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/pages/topup_pensiun.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MainPensiun extends StatefulWidget {
  const MainPensiun({super.key});

  @override
  State<MainPensiun> createState() => _MainPensiunState();
}

class _MainPensiunState extends State<MainPensiun> {
  final MainpensiunBloc _bloc = MainpensiunBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(FetchMainPensiun());
  }

  String _formatRupiah(int value) {
    final s = value.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc,
      child: BlocBuilder<MainpensiunBloc, MainpensiunState>(
        builder: (context, state) {
          if (state is MainpensiunLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MainpensiunError) {
            return Center(child: Text("Gagal: ${state.message}"));
          } else if (state is MainpensiunLoaded) {
            final pension = state.pension;
            final double progress = pension.currentAmount / pension.targetAmount;
            final percentage = (progress * 100).clamp(0, 100).toInt();

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: AppColors.primary100,
                        child: Icon(Icons.shield, color: AppColors.primary800),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rencana Pensiun",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Pantau dan tingkatkan tabungan pensiun kamu",
                              style: TextStyle(color: Colors.black54, fontSize: 13),
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
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Rencana Dana Pensiun",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _infoRow("Target", "Rp ${_formatRupiah(pension.targetAmount)}"),
                  _infoRow("Terkumpul", "Rp ${_formatRupiah(pension.currentAmount)}"),
                  _infoRow("Deskripsi", pension.description),
                  _infoRow(
                    "Deadline",
                    "${pension.deadline.day}/${pension.deadline.month}/${pension.deadline.year}",
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TopUpPensiun()),
                      );
                      _bloc.add(FetchMainPensiun());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text("Top Up", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () async {
                      _bloc.add(FetchMainPensiun());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 230, 47, 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text("Withdraw", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("Data tidak tersedia"));
        },
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
}