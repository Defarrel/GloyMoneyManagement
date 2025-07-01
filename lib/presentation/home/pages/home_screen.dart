import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/response/menabung/menabung_reponse_model.dart';
import 'package:gloymoneymanagement/data/models/response/pensiun/pensiun_response_model.dart';
import 'package:gloymoneymanagement/data/models/response/transaksi/transaction_response_model.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/presentation/home/pages/home_root.dart';
import 'package:gloymoneymanagement/presentation/transaksi/pages/riwayat_transaksi.dart';
import 'package:gloymoneymanagement/presentation/transaksi/pages/tambah_transaksi.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _transactionRepo = TransactionRepository(ServiceHttpClient());
  final _pensionRepo = PensionRepository(ServiceHttpClient());
  final _savingRepo = SavingRepository(ServiceHttpClient());

  List<TransactionResponseModel> _transactions = [];
  PensionResponseModel? _pension;
  List<SavingResponseModel> _savings = [];
  int _saldo = 0;
  int _pemasukan = 0;
  int _pengeluaran = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _loadTransactions(),
      _loadPension(),
      _loadSavings(),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> _loadTransactions() async {
    final result = await _transactionRepo.getTransactions();
    result.fold(
      (error) => _showError(error),
      (data) {
        final pemasukan = data.where((t) => t.type.toLowerCase() == 'pemasukan')
            .fold<int>(0, (sum, t) => sum + t.amount.toInt());
        final pengeluaran = data.where((t) => t.type.toLowerCase() == 'pengeluaran')
            .fold<int>(0, (sum, t) => sum + t.amount.toInt());

        _transactions = data;
        _pemasukan = pemasukan;
        _pengeluaran = pengeluaran;
        _saldo = pemasukan - pengeluaran;
      },
    );
  }

  Future<void> _loadPension() async {
    final result = await _pensionRepo.getPension();
    result.fold(
      (error) => _showError(error),
      (data) => _pension = data,
    );
  }

  Future<void> _loadSavings() async {
    final result = await _savingRepo.getAllSavings();
    result.fold(
      (error) => _showError(error),
      (data) => _savings = data,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
      appBar: CustomAppBar(title: "Gloy Money Management", showLogo: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAll,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSaldoHeader(theme),
                    const SizedBox(height: 12),
                    _buildMenuNavigasi(),
                    const SizedBox(height: 12),
                    _buildTransaksiBaruButton(),
                    const SizedBox(height: 12),
                    if (_pension != null) _buildKartuPensiun(),
                    const SizedBox(height: 16),
                    _buildJudulSection("Tabungan Bersama"),
                    ..._savings.map((saving) => _buildSavingItem(saving)).toList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSaldoHeader(ThemeData theme) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Saldo Anda", style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Text("Rp ${_formatRupiah(_saldo)}",
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text("Pengeluaran\nRp ${_formatRupiah(_pengeluaran)}",
                    style: const TextStyle(color: Colors.red)),
              ),
              Expanded(
                child: Text("Pemasukan\nRp ${_formatRupiah(_pemasukan)}",
                    style: const TextStyle(color: Colors.green), textAlign: TextAlign.right),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuNavigasi() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _homeMenuItem(Icons.receipt, "Transaksi", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RiwayatTransaksi())).then((_) => _loadAll());
          }),
          _homeMenuItem(Icons.bar_chart, "Portofolio", () {}),
          _homeMenuItem(Icons.savings, "Menabung", () => HomeRoot.navigateToTab(context, 1)),
          _homeMenuItem(Icons.timelapse, "Pensiun", () => HomeRoot.navigateToTab(context, 2)),
        ],
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

  Widget _buildTransaksiBaruButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TambahTransaksi())).then((_) => _loadAll());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary800,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minimumSize: const Size.fromHeight(40),
        ),
        child: const Text("Transaksi Baru", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildKartuPensiun() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Rencana Pensiun", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Investasi", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text("Rp ${_formatRupiah(_pension!.currentAmount)}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Target", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text("Rp ${_formatRupiah(_pension!.targetAmount)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => HomeRoot.navigateToTab(context, 2),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary800,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              minimumSize: const Size.fromHeight(40),
            ),
            child: const Text("Top Up", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildJudulSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildSavingItem(SavingResponseModel saving) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(saving.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Terkumpul", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text("Rp ${_formatRupiah(saving.currentAmount)}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Target", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text("Rp ${_formatRupiah(saving.targetAmount)}",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
