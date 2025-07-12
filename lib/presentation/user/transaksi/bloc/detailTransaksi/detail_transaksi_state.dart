part of 'detail_transaksi_bloc.dart';

abstract class DetailTransaksiState extends Equatable {
  const DetailTransaksiState();

  @override
  List<Object> get props => [];
}

class DetailTransaksiInitial extends DetailTransaksiState {}

class DetailTransaksiLoading extends DetailTransaksiState {}

class DetailTransaksiDeleted extends DetailTransaksiState {}

class DetailTransaksiError extends DetailTransaksiState {
  final String message;

  const DetailTransaksiError(this.message);

  @override
  List<Object> get props => [message];
}
