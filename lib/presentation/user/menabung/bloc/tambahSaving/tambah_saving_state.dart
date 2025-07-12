abstract class TambahSavingState {}

class TambahSavingInitial extends TambahSavingState {}

class TambahSavingLoading extends TambahSavingState {}

class TambahSavingSuccess extends TambahSavingState {}

class TambahSavingFailure extends TambahSavingState {
  final String message;

  TambahSavingFailure(this.message);
}
