part of 'home_screen_bloc.dart';

sealed class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object?> get props => [];
}

final class HomeScreenInitial extends HomeScreenState {}

final class HomeScreenLoading extends HomeScreenState {}

final class HomeScreenError extends HomeScreenState {
  final String message;

  const HomeScreenError(this.message);

  @override
  List<Object?> get props => [message];
}

final class HomeScreenLoaded extends HomeScreenState {
  final List<TransactionResponseModel> transactions;
  final PensionResponseModel? pension;
  final List<SavingResponseModel> savings;
  final int pemasukan;
  final int pengeluaran;
  final int saldo;

  const HomeScreenLoaded({
    required this.transactions,
    required this.pension,
    required this.savings,
    required this.pemasukan,
    required this.pengeluaran,
    required this.saldo,
  });

  @override
  List<Object?> get props => [
        transactions,
        pension,
        savings,
        pemasukan,
        pengeluaran,
        saldo,
      ];
}
