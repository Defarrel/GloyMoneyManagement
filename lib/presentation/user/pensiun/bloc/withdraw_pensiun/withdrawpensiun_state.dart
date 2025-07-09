part of 'withdrawpensiun_bloc.dart';

sealed class WithdrawpensiunState extends Equatable {
  const WithdrawpensiunState();

  @override
  List<Object> get props => [];
}

final class WithdrawpensiunInitial extends WithdrawpensiunState {}

final class WithdrawpensiunLoading extends WithdrawpensiunState {}

final class WithdrawpensiunSuccess extends WithdrawpensiunState {}

final class WithdrawpensiunFailure extends WithdrawpensiunState {
  final String message;

  const WithdrawpensiunFailure(this.message);

  @override
  List<Object> get props => [message];
}
