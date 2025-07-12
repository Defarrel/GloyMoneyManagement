part of 'riwayat_transaksi_bloc.dart';

abstract class RiwayatTransaksiState extends Equatable {
  const RiwayatTransaksiState();

  @override
  List<Object> get props => [];
}

class RiwayatTransaksiInitial extends RiwayatTransaksiState {}

class RiwayatTransaksiLoading extends RiwayatTransaksiState {}

class RiwayatTransaksiLoaded extends RiwayatTransaksiState {
  final List<TransactionResponseModel> transactions;

  const RiwayatTransaksiLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class RiwayatTransaksiError extends RiwayatTransaksiState {
  final String message;

  const RiwayatTransaksiError(this.message);

  @override
  List<Object> get props => [message];
}
