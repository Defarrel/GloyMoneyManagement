import 'package:flutter/material.dart';

class TambahTransaksi extends StatefulWidget {
  const TambahTransaksi({super.key});

  @override
  State<TambahTransaksi> createState() => _TambahTransaksiState();
}

class _TambahTransaksiState extends State<TambahTransaksi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Tambah Transaksi')));
  }
}
