import 'package:gloymoneymanagement/data/models/response/menabung/menabung_reponse_model.dart';

abstract class SavingDetailState {}

class SavingDetailInitial extends SavingDetailState {}

class SavingDetailLoading extends SavingDetailState {}

class SavingDetailLoaded extends SavingDetailState {
  final SavingResponseModel saving;

  SavingDetailLoaded(this.saving);
}

class SavingDetailError extends SavingDetailState {
  final String message;

  SavingDetailError(this.message);
}
