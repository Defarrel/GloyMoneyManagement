import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/response/menabung/menabung_reponse_model.dart';
import 'package:gloymoneymanagement/data/models/response/pensiun/pensiun_response_model.dart';
import 'package:gloymoneymanagement/data/models/response/transaksi/transaction_response_model.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/presentation/user/home/pages/home_root.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/riwayat_transaksi.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/tambah_transaksi.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _GrafikData {
  final String label;
  final double value;
  _GrafikData(this.label, this.value);
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
  int _grafikIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _isLoading = true);
    await Future.wait([_loadTransactions(), _loadPension(), _loadSavings()]);
    setState(() => _isLoading = false);
  }

  Future<void> _loadTransactions() async {
    final result = await _transactionRepo.getTransactions();
    result.fold((error) => _showError(error), (data) {
      final pemasukan = data
          .where((t) => t.type.toLowerCase() == 'pemasukan')
          .fold<int>(0, (sum, t) => sum + t.amount.toInt());
      final pengeluaran = data
          .where((t) => t.type.toLowerCase() == 'pengeluaran')
          .fold<int>(0, (sum, t) => sum + t.amount.toInt());

      _transactions = data;
      _pemasukan = pemasukan;
      _pengeluaran = pengeluaran;
      _saldo = pemasukan - pengeluaran;
    });
  }

  Future<void> _loadPension() async {
    final result = await _pensionRepo.getPension();
    result.fold((error) => _showError(error), (data) => _pension = data);
  }

  Future<void> _loadSavings() async {
    final result = await _savingRepo.getAllSavings();
    result.fold((error) => _showError(error), (data) => _savings = data);
  }

  void _showError(String error) {
    if (error == 'Dana pensiun belum dibuat') return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  String _formatRupiah(int value) {
    final s = value.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '.');
  }

  Widget _buildGrafik() {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;
    final maxDay = DateUtils.getDaysInMonth(currentYear, currentMonth);

    List<double> pemasukanHarian = List.filled(maxDay, 0);
    List<double> pengeluaranHarian = List.filled(maxDay, 0);
    List<double> pemasukanBulanan = List.filled(12, 0);
    List<double> pengeluaranBulanan = List.filled(12, 0);

    for (final transaksi in _transactions) {
      final tanggal = transaksi.date;
      if (tanggal == null) continue;
      final amount = transaksi.amount.toDouble();

      if (tanggal.year == currentYear && tanggal.month == currentMonth) {
        final day = tanggal.day - 1;
        if (transaksi.type.toLowerCase() == 'pemasukan') {
          pemasukanHarian[day] += amount;
        } else {
          pengeluaranHarian[day] += amount;
        }
      }

      if (tanggal.year == currentYear) {
        final month = tanggal.month - 1;
        if (transaksi.type.toLowerCase() == 'pemasukan') {
          pemasukanBulanan[month] += amount;
        } else {
          pengeluaranBulanan[month] += amount;
        }
      }
    }

    List<_GrafikData> pemasukanData = [];
    List<_GrafikData> pengeluaranData = [];

    if (_grafikIndex == 0) {
      final hariIni = DateTime.now();
      final tujuhHariLalu = hariIni.subtract(const Duration(days: 6));

      for (int i = 0; i < 7; i++) {
        final tgl = tujuhHariLalu.add(Duration(days: i));

        double pemasukan = 0;
        double pengeluaran = 0;

        for (final transaksi in _transactions) {
          if (transaksi.date != null &&
              transaksi.date.day == tgl.day &&
              transaksi.date.month == tgl.month &&
              transaksi.date.year == tgl.year) {
            if (transaksi.type.toLowerCase() == 'pemasukan') {
              pemasukan += transaksi.amount;
            } else {
              pengeluaran += transaksi.amount;
            }
          }
        }

        final label = "${tgl.day}";
        pemasukanData.add(_GrafikData(label, pemasukan / 1e6));
        pengeluaranData.add(_GrafikData(label, pengeluaran / 1e6));
      }
    } else {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      final bulanTerakhir = currentMonth;
      final bulanMulai = (bulanTerakhir - 4 < 0) ? 0 : bulanTerakhir - 4;

      for (int i = bulanMulai; i < bulanTerakhir; i++) {
        pemasukanData.add(_GrafikData(months[i], pemasukanBulanan[i] / 1e6));
        pengeluaranData.add(
          _GrafikData(months[i], pengeluaranBulanan[i] / 1e6),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  "Grafik Keuangan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _grafikIndex,
                      iconSize: 16,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text("Bulanan")),
                        DropdownMenuItem(value: 0, child: Text("Harian")),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _grafikIndex = val);
                        }
                      },
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: SfCartesianChart(
                legend: Legend(isVisible: true),
                primaryXAxis: CategoryAxis(
                  labelPlacement: LabelPlacement.onTicks,
                  interval: 1,
                ),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value} Jt',
                  numberFormat: NumberFormat.compact(),
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: [
                  SplineAreaSeries<_GrafikData, String>(
                    dataSource: pemasukanData,
                    xValueMapper: (data, _) => data.label,
                    yValueMapper: (data, _) => data.value,
                    name: 'Pemasukan',
                    gradient: LinearGradient(
                      colors: [Colors.green.shade100, Colors.green.shade400],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  SplineAreaSeries<_GrafikData, String>(
                    dataSource: pengeluaranData,
                    xValueMapper: (data, _) => data.label,
                    yValueMapper: (data, _) => data.value,
                    name: 'Pengeluaran',
                    gradient: LinearGradient(
                      colors: [Colors.red.shade100, Colors.red.shade400],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                    _buildGrafik(),
                    const SizedBox(height: 12),
                    _buildMenuNavigasi(),
                    const SizedBox(height: 12),
                    _buildTransaksiBaruButton(),
                    const SizedBox(height: 12),
                    if (_pension != null) _buildKartuPensiun(),
                    const SizedBox(height: 16),
                    _buildJudulSection("Tabungan Bersama"),
                    ..._savings.map((saving) => _buildSavingItem(saving)),
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
          Text(
            "Rp ${_formatRupiah(_saldo)}",
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RiwayatTransaksi()),
            ).then((_) => _loadAll());
          }),
          _homeMenuItem(Icons.bar_chart, "Portofolio", () {}),
          _homeMenuItem(
            Icons.savings,
            "Menabung",
            () => HomeRoot.navigateToTab(context, 1),
          ),
          _homeMenuItem(
            Icons.timelapse,
            "Pensiun",
            () => HomeRoot.navigateToTab(context, 2),
          ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahTransaksi()),
          ).then((_) => _loadAll());
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
          const Text(
            "Rencana Pensiun",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Investasi",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Rp ${_formatRupiah(_pension!.currentAmount)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Target", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      "Rp ${_formatRupiah(_pension!.targetAmount)}",
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
          ElevatedButton(
            onPressed: () => HomeRoot.navigateToTab(context, 2),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Terkumpul", style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(
                      "Rp ${_formatRupiah(saving.currentAmount)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Target", style: TextStyle(fontSize: 12)),
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
        ],
      ),
    );
  }
}
