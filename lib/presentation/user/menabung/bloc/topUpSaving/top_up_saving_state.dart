abstract class TopUpSavingState {}

class TopUpSavingInitial extends TopUpSavingState {}

class TopUpSavingLoading extends TopUpSavingState {}

class TopUpSavingSuccess extends TopUpSavingState {
  final String message;
  TopUpSavingSuccess(this.message);
}

class TopUpSavingFailure extends TopUpSavingState {
  final String error;
  TopUpSavingFailure(this.error);
}
