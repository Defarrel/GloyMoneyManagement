abstract class WithdrawSavingState {}

class WithdrawSavingInitial extends WithdrawSavingState {}

class WithdrawSavingLoading extends WithdrawSavingState {}

class WithdrawSavingSuccess extends WithdrawSavingState {
  final String message;
  WithdrawSavingSuccess(this.message);
}

class WithdrawSavingFailure extends WithdrawSavingState {
  final String error;
  WithdrawSavingFailure(this.error);
}
