import 'package:flutter/material.dart';

class RiwayatTransaksi extends StatefulWidget {
  const RiwayatTransaksi({super.key});

  @override
  State<RiwayatTransaksi> createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const Center(child: Text('Riwayat Transaksi')));
  }
}
