import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/bloc/detailTransaksi/detail_transaksi_bloc.dart';

part 'detail_transaksi_event.dart';
part 'detail_transaksi_state.dart';

class DetailTransaksiBloc
    extends Bloc<DetailTransaksiEvent, DetailTransaksiState> {
  final TransactionRepository repository;

  DetailTransaksiBloc({required this.repository})
    : super(DetailTransaksiInitial()) {
    on<DeleteTransactionRequested>(_onDeleteTransactionRequested);
  }

  Future<void> _onDeleteTransactionRequested(
    DeleteTransactionRequested event,
    Emitter<DetailTransaksiState> emit,
  ) async {
    emit(DetailTransaksiLoading());
    final result = await repository.deleteTransaction(event.id);
    result.fold(
      (err) => emit(DetailTransaksiError(err)),
      (_) => emit(DetailTransaksiDeleted()),
    );
  }
}
