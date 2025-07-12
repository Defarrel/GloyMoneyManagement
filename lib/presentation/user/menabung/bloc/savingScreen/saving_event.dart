import 'package:gloymoneymanagement/data/models/response/menabung/menabung_reponse_model.dart';

abstract class SavingEvent {}

class LoadAllSavingEvent extends SavingEvent {}

class LoadSavingDetailEvent extends SavingEvent {
  final int id;
  final Function(SavingResponseModel detail)? onSuccess;
  final Function(String error)? onError;

  LoadSavingDetailEvent({
    required this.id,
    this.onSuccess,
    this.onError,
  });
}
