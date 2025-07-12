import 'package:gloymoneymanagement/data/models/response/menabung/menabung_reponse_model.dart';

abstract class SavingState {}

class SavingInitial extends SavingState {}

class SavingLoading extends SavingState {}

class SavingLoaded extends SavingState {
  final List<SavingResponseModel> savings;

  SavingLoaded(this.savings);
}

class SavingError extends SavingState {
  final String message;

  SavingError(this.message);
}
