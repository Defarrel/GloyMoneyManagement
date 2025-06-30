import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/response/pensiun/pensiun_response_model.dart';
import 'package:gloymoneymanagement/presentation/pensiun/topup_pensiun.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MainPensiun extends StatelessWidget {
  final PensionResponseModel pension;
  final VoidCallback onRefresh;

  const MainPensiun({
    super.key,
    required this.pension,
    required this.onRefresh,
  });

  String _formatRupiah(int value) {
    final s = value.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    final double progress = pension.currentAmount / pension.targetAmount;
    final percentage = (progress * 100).clamp(0, 100).toInt();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Icon + Judul
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.primary100,
                child: Icon(Icons.shield, color: AppColors.primary800),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
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

          // Circular progress
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

          // Detail
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

          // Button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TopUpPensiun()),
              ).then((_) => onRefresh());
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TopUpPensiun()),
              ).then((_) => onRefresh());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 230, 47, 6),
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
