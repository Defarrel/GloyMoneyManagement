import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/response/transaksi/transaction_response_model.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

part 'riwayat_transaksi_event.dart';
part 'riwayat_transaksi_state.dart';

class RiwayatTransaksiBloc extends Bloc<RiwayatTransaksiEvent, RiwayatTransaksiState> {
  final TransactionRepository repository;

  RiwayatTransaksiBloc({required this.repository}) : super(RiwayatTransaksiInitial()) {
    on<LoadRiwayatTransaksi>(_onLoadRiwayatTransaksi);
  }

  Future<void> _onLoadRiwayatTransaksi(
    LoadRiwayatTransaksi event,
    Emitter<RiwayatTransaksiState> emit,
  ) async {
    emit(RiwayatTransaksiLoading());
    final result = await repository.getTransactions();
    result.fold(
      (error) => emit(RiwayatTransaksiError(error)),
      (data) => emit(RiwayatTransaksiLoaded(data)),
    );
  }
}
