import 'package:gloymoneymanagement/data/models/response/menabung/join_menabung_response_model.dart';

abstract class RiwayatSavingState {}

class RiwayatSavingInitial extends RiwayatSavingState {}

class RiwayatSavingLoading extends RiwayatSavingState {}

class RiwayatSavingLoaded extends RiwayatSavingState {
  final List<JointSavingResponseModel> data;
  RiwayatSavingLoaded(this.data);
}

class RiwayatSavingFailure extends RiwayatSavingState {
  final String message;
  RiwayatSavingFailure(this.message);
}
