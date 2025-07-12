import 'package:gloymoneymanagement/data/models/response/akun/akun_response_model.dart';

abstract class InvtSavingState {}

class InvtSavingInitial extends InvtSavingState {}

class InvtSavingLoading extends InvtSavingState {}

class InvtSavingLoaded extends InvtSavingState {
  final List<AkunResponseModel> users;
  final int currentUserId;

  InvtSavingLoaded(this.users, this.currentUserId);
}

class InvtSavingError extends InvtSavingState {
  final String message;
  InvtSavingError(this.message);
}

class InvtSavingSuccessMessage extends InvtSavingState {
  final String message;
  InvtSavingSuccessMessage(this.message);
}
