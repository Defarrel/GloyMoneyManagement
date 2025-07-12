part of 'tambah_transaksi_bloc.dart';

sealed class TambahTransaksiEvent extends Equatable {
  const TambahTransaksiEvent();

  @override
  List<Object> get props => [];
}

class SubmitTambahTransaksi extends TambahTransaksiEvent {
  final TransactionRequestModel model;

  const SubmitTambahTransaksi(this.model);

  @override
  List<Object> get props => [model];
}
