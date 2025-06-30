import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/response/transaksi/transaction_response_model.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/presentation/transaksi/pages/riwayat_transaksi.dart';
import 'package:gloymoneymanagement/presentation/transaksi/pages/tambah_transaksi.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = TransactionRepository(ServiceHttpClient());
  List<TransactionResponseModel> _transactions = [];
  int _saldo = 0;
  int _pemasukan = 0;
  int _pengeluaran = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    final result = await _repo.getTransactions();
    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        setState(() => _isLoading = false);
      },
      (data) {
        final pemasukan = data
            .where((t) => t.type.toLowerCase() == 'pemasukan')
            .fold<int>(0, (sum, t) => sum + t.amount.toInt());
        final pengeluaran = data
            .where((t) => t.type.toLowerCase() == 'pengeluaran')
            .fold<int>(0, (sum, t) => sum + t.amount.toInt());
        setState(() {
          _transactions = data;
          _pemasukan = pemasukan;
          _pengeluaran = pengeluaran;
          _saldo = pemasukan - pengeluaran;
          _isLoading = false;
        });
      },
    );
  }

  String _formatRupiah(int value) {
    final s = value.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: CustomAppBar(
        title: "Gloy Money Management",
        showLogo: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Saldo Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Saldo Anda",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isLoading ? "Memuat..." : "Rp ${_formatRupiah(_saldo)}",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Pengeluaran\nRp ${_formatRupiah(_pengeluaran)}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Pemasukan\nRp ${_formatRupiah(_pemasukan)}",
                          style: const TextStyle(color: Colors.green),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Menu Navigasi
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _homeMenuItem(Icons.receipt, "Transaksi", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RiwayatTransaksi(),
                      ),
                    ).then((_) => _loadTransactions());
                  }),
                  _homeMenuItem(Icons.bar_chart, "Portofolio", () {}),
                  _homeMenuItem(Icons.savings, "Menabung", () {}),
                  _homeMenuItem(Icons.timelapse, "Pensiun", () {}),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Transaksi Baru
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TambahTransaksi()),
                  ).then((_) => _loadTransactions());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size.fromHeight(40),
                ),
                child: const Text(
                  "Transaksi Baru",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Kartu Rencana Pensiun
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  const Text("Rencana Pensiun"),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Investasi", style: TextStyle(fontSize: 12)),
                            SizedBox(height: 4),
                            Text("Rp 3.000.000", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Keuntungan", style: TextStyle(fontSize: 12)),
                            SizedBox(height: 4),
                            Text(
                              "Rp 540.000",
                              style: TextStyle(
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
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text(
                      "Top Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _homeMenuItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
