part of 'topuppensiun_bloc.dart';

abstract class TopupPensiunEvent extends Equatable {
  const TopupPensiunEvent();

  @override
  List<Object?> get props => [];
}

class SubmitTopupPensiun extends TopupPensiunEvent {
  final int amount;

  const SubmitTopupPensiun(this.amount);

  @override
  List<Object?> get props => [amount];
}
