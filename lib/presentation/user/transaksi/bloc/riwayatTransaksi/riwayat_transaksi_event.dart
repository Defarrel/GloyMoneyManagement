part of 'riwayat_transaksi_bloc.dart';

abstract class RiwayatTransaksiEvent extends Equatable {
  const RiwayatTransaksiEvent();

  @override
  List<Object> get props => [];
}

class LoadRiwayatTransaksi extends RiwayatTransaksiEvent {}
