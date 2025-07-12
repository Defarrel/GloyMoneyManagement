import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';

class Saham extends StatefulWidget {
  const Saham({super.key});

  @override
  State<Saham> createState() => _SahamState();
}

class _SahamState extends State<Saham> {
  final List<Map<String, String>> _bluechipStocks = [
    {'name': 'Bank BCA', 'symbol': 'BBCA.JK', 'logo': 'bca.co.id'},
    {'name': 'Bank BRI', 'symbol': 'BBRI.JK', 'logo': 'bri.co.id'},
    {'name': 'Telkom Indonesia', 'symbol': 'TLKM.JK', 'logo': 'telkom.co.id'},
    {'name': 'Astra International', 'symbol': 'ASII.JK', 'logo': 'astra.co.id'},
    {
      'name': 'Unilever Indonesia',
      'symbol': 'UNVR.JK',
      'logo': 'unilever.co.id',
    },
    {'name': 'Bank Mandiri', 'symbol': 'BMRI.JK', 'logo': 'bankmandiri.co.id'},
    {'name': 'Indofood CBP', 'symbol': 'ICBP.JK', 'logo': 'indofoodcbp.com'},
    {'name': 'Gudang Garam', 'symbol': 'GGRM.JK', 'logo': 'gudanggaramtbk.com'},
    {'name': 'Kalbe Farma', 'symbol': 'KLBF.JK', 'logo': 'kalbe.co.id'},
    {'name': 'Indofood Sukses', 'symbol': 'INDF.JK', 'logo': 'indofood.com'},
    {
      'name': 'Solusi Sinergi Digital (WIFI)',
      'symbol': 'WIFI.JK',
      'logo': 'sosdg.co.id',
    },
    {'name': 'Petrosea (PTRO)', 'symbol': 'PTRO.JK', 'logo': 'petrosea.com'},
    {
      'name': 'Central Omega Resources (DKFT)',
      'symbol': 'DKFT.JK',
      'logo': 'centralomega.com',
    },
    {
      'name': 'Semen Indonesia',
      'symbol': 'SMGR.JK',
      'logo': 'semenindonesia.com',
    },
    {'name': 'Bank BTN', 'symbol': 'BBTN.JK', 'logo': 'btn.co.id'},
    {'name': 'Aneka Tambang', 'symbol': 'ANTM.JK', 'logo': 'antam.com'},
    {'name': 'Chandra Asri', 'symbol': 'TPIA.JK', 'logo': 'capcx.com'},
    {
      'name': 'Barito Pacific',
      'symbol': 'BRPT.JK',
      'logo': 'barito-pacific.com',
    },
    {'name': 'Tower Bersama', 'symbol': 'TBIG.JK', 'logo': 'tower-bersama.com'},
  ];

  final Map<String, double> _stockPrices = {};
  final Map<String, double> _stockChanges = {};
  final Map<String, List<FlSpot>> _chartData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPrices();
  }

  Future<void> _fetchPrices() async {
    setState(() => _isLoading = true);

    for (final stock in _bluechipStocks) {
      final symbol = stock['symbol']!;
      try {
        final uri = Uri.parse(
          'https://query1.finance.yahoo.com/v8/finance/chart/$symbol?interval=5m&range=1d',
        );
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final results = data['chart']['result'];
          if (results == null || results.isEmpty) continue;

          final result = results[0];
          final meta = result['meta'];
          final price = meta?['regularMarketPrice'];
          final prevClose = meta?['chartPreviousClose'];

          if (price != null) {
            _stockPrices[symbol] = price.toDouble();
            if (prevClose != null && prevClose != 0) {
              final change = ((price - prevClose) / prevClose) * 100;
              _stockChanges[symbol] = change;
            }
          }

          final timestamps = result['timestamp'];
          final closes = result['indicators']['quote'][0]['close'];

          if (timestamps != null && closes != null) {
            final List<FlSpot> spots = [];
            for (int i = 0; i < timestamps.length; i++) {
              final p = closes[i];
              if (p != null) {
                spots.add(FlSpot(i.toDouble(), p.toDouble()));
              }
            }
            if (spots.length >= 4) {
              _chartData[symbol] = spots;
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching $symbol: $e');
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Saham Indonesia", showLogo: true),
      backgroundColor: const Color(0xFFF4F6F8),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchPrices,
              child: ListView.builder(
                itemCount: _bluechipStocks.length,
                itemBuilder: (context, index) {
                  final stock = _bluechipStocks[index];
                  final symbol = stock['symbol']!;
                  final name = stock['name']!;
                  final logo = stock['logo']!;
                  final displaySymbol = symbol.replaceAll('.JK', '');
                  final price = _stockPrices[symbol];
                  final change = _stockChanges[symbol];
                  final chart = _chartData[symbol];
                  final isPositive = (change ?? 0) >= 0;

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://logo.clearbit.com/$logo',
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.business, size: 40),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                displaySymbol,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              if (price != null)
                                Row(
                                  children: [
                                    Text(
                                      "Rp ${price.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (change != null)
                                      Text(
                                        "${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}%",
                                        style: TextStyle(
                                          color: isPositive
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        if (chart != null)
                          SizedBox(
                            width: 80,
                            height: 50,
                            child: LineChart(
                              LineChartData(
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: chart,
                                    isCurved: true,
                                    dotData: FlDotData(show: false),
                                    color: isPositive
                                        ? Colors.green
                                        : Colors.red,
                                    barWidth: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
