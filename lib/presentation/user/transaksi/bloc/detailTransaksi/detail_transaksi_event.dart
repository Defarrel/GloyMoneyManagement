part of 'detail_transaksi_bloc.dart';

abstract class DetailTransaksiEvent extends Equatable {
  const DetailTransaksiEvent();

  @override
  List<Object> get props => [];
}

class DeleteTransactionRequested extends DetailTransaksiEvent {
  final int id;

  const DeleteTransactionRequested(this.id);

  @override
  List<Object> get props => [id];
}
