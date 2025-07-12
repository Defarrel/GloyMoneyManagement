import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/data/models/response/transaksi/transaction_response_model.dart';
import 'package:gloymoneymanagement/presentation/user/home/bloc/homeScreen/home_screen_bloc.dart';
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
  int _grafikIndex = 1;

  @override
  void initState() {
    super.initState();
    context.read<HomeScreenBloc>().add(FetchHomeData());
  }

  String _formatRupiah(int value) {
    final s = value.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '.');
  }

  Widget _buildGrafik(List<TransactionResponseModel> transactions) {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;
    final maxDay = DateUtils.getDaysInMonth(currentYear, currentMonth);

    List<double> pemasukanHarian = List.filled(maxDay, 0);
    List<double> pengeluaranHarian = List.filled(maxDay, 0);
    List<double> pemasukanBulanan = List.filled(12, 0);
    List<double> pengeluaranBulanan = List.filled(12, 0);

    for (final transaksi in transactions) {
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

        for (final transaksi in transactions) {
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

    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        if (state is HomeScreenLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFF4F6F8),
            appBar: CustomAppBar(
              title: "Gloy Money Management",
              showLogo: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is HomeScreenError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F6F8),
            appBar: CustomAppBar(
              title: "Gloy Money Management",
              showLogo: true,
            ),
            body: Center(child: Text(state.message)),
          );
        } else if (state is HomeScreenLoaded) {
          return Scaffold(
            backgroundColor: const Color(0xFFF4F6F8),
            appBar: CustomAppBar(
              title: "Gloy Money Management",
              showLogo: true,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeScreenBloc>().add(FetchHomeData());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Reuse original widget logic here, using state.pemasukan, etc.
                    // Example:
                    // _buildSaldoHeader(theme, state.saldo, state.pemasukan, state.pengeluaran),
                    // _buildGrafik(state.transactions),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
