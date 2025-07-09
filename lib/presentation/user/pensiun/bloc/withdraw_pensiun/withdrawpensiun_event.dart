part of 'withdrawpensiun_bloc.dart';

sealed class WithdrawpensiunEvent extends Equatable {
  const WithdrawpensiunEvent();

  @override
  List<Object> get props => [];
}

class SubmitWithdrawPensiun extends WithdrawpensiunEvent {
  final int amount;

  const SubmitWithdrawPensiun(this.amount);

  @override
  List<Object> get props => [amount];
}
