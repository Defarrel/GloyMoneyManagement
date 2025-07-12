part of 'tambah_transaksi_bloc.dart';

sealed class TambahTransaksiState extends Equatable {
  const TambahTransaksiState();

  @override
  List<Object> get props => [];
}

final class TambahTransaksiInitial extends TambahTransaksiState {}

final class TambahTransaksiLoading extends TambahTransaksiState {}

final class TambahTransaksiSuccess extends TambahTransaksiState {}

final class TambahTransaksiError extends TambahTransaksiState {
  final String message;

  const TambahTransaksiError(this.message);

  @override
  List<Object> get props => [message];
}
