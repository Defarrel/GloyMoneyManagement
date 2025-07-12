import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/request/transaksi/transaction_request_model.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

part 'tambah_transaksi_event.dart';
part 'tambah_transaksi_state.dart';

class TambahTransaksiBloc extends Bloc<TambahTransaksiEvent, TambahTransaksiState> {
  final TransactionRepository repository;

  TambahTransaksiBloc({required this.repository}) : super(TambahTransaksiInitial()) {
    on<SubmitTambahTransaksi>(_onSubmitTambahTransaksi);
  }

  Future<void> _onSubmitTambahTransaksi(
    SubmitTambahTransaksi event,
    Emitter<TambahTransaksiState> emit,
  ) async {
    emit(TambahTransaksiLoading());
    final result = await repository.addTransaction(event.model);
    result.fold(
      (error) => emit(TambahTransaksiError(error)),
      (success) => emit(TambahTransaksiSuccess()),
    );
  }
}