import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gloymoneymanagement/data/models/response/menabung/menabung_reponse_model.dart';
import 'package:gloymoneymanagement/data/models/response/pensiun/pensiun_response_model.dart';
import 'package:gloymoneymanagement/data/models/response/transaksi/transaction_response_model.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final _transactionRepo = TransactionRepository(ServiceHttpClient());
  final _pensionRepo = PensionRepository(ServiceHttpClient());
  final _savingRepo = SavingRepository(ServiceHttpClient());

  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
    FetchHomeData event,
    Emitter<HomeScreenState> emit,
  ) async {
    emit(HomeScreenLoading());
    try {
      final transaksiResult = await _transactionRepo.getTransactions();
      final pensiunResult = await _pensionRepo.getPension();
      final savingResult = await _savingRepo.getAllSavings();

      transaksiResult.fold(
        (error) => emit(HomeScreenError(error)),
        (transactions) {
          final pemasukan = transactions
              .where((t) => t.type.toLowerCase() == 'pemasukan')
              .fold<int>(0, (sum, t) => sum + t.amount.toInt());

          final pengeluaran = transactions
              .where((t) => t.type.toLowerCase() == 'pengeluaran')
              .fold<int>(0, (sum, t) => sum + t.amount.toInt());

          final saldo = pemasukan - pengeluaran;

          pensiunResult.fold(
            (error) {
              if (error != 'Dana pensiun belum dibuat') {
                emit(HomeScreenError(error));
              } else {
                savingResult.fold(
                  (e) => emit(HomeScreenError(e)),
                  (savings) => emit(
                    HomeScreenLoaded(
                      transactions: transactions,
                      pension: null,
                      savings: savings,
                      pemasukan: pemasukan,
                      pengeluaran: pengeluaran,
                      saldo: saldo,
                    ),
                  ),
                );
              }
            },
            (pension) {
              savingResult.fold(
                (e) => emit(HomeScreenError(e)),
                (savings) => emit(
                  HomeScreenLoaded(
                    transactions: transactions,
                    pension: pension,
                    savings: savings,
                    pemasukan: pemasukan,
                    pengeluaran: pengeluaran,
                    saldo: saldo,
                  ),
                ),
              );
            },
          );
        },
      );
    } catch (e) {
      emit(HomeScreenError(e.toString()));
    }
  }
}