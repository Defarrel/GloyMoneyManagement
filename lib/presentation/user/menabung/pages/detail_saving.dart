import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/response/menabung/menabung_reponse_model.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/pages/riwayat_saving.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/pages/top_up_saving.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/pages/withdraw_saving.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetailSaving extends StatelessWidget {
  final SavingResponseModel saving;
  final VoidCallback onRefresh;

  const DetailSaving({
    super.key,
    required this.saving,
    required this.onRefresh,
  });

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
    final double progress = saving.currentAmount / saving.targetAmount;
    final percentage = (progress * 100).clamp(0, 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: CustomAppBar(title: "Detail Tabungan", showLogo: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Percentage
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
            const SizedBox(height: 40),

            // Detail Info
            const Text(
              "Detail Tabungan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _infoRow("Judul", saving.title),
            _infoRow("Target", "Rp ${_formatRupiah(saving.targetAmount)}"),
            _infoRow("Terkumpul", "Rp ${_formatRupiah(saving.currentAmount)}"),
            _infoRow("Deadline", _formatDate(saving.deadline)),

            const SizedBox(height: 24),

            // Anggota Tabungan + Undang
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Anggota Tabungan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                OutlinedButton(
                  onPressed: () {},
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
                  child: Icon(Icons.person, color: AppColors.primary800),
                ),
                title: Text(member.name),
                subtitle: Text("Rp ${_formatRupiah(member.amount)}"),
              ),
            ),

            const SizedBox(height: 32),

            // Action Box
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
                          builder: (_) => RiwayatSaving(savingId: saving.id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
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
