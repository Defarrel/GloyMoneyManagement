part of 'riwayat_transaksi_bloc.dart';

sealed class RiwayatTransaksiState extends Equatable {
  const RiwayatTransaksiState();
  
  @override
  List<Object> get props => [];
}

final class RiwayatTransaksiInitial extends RiwayatTransaksiState {}
