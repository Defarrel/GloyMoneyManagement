part of 'login_bloc.dart';

sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final AuthResponseModel responseModel;
  
  LoginSuccess({required this.responseModel});
}


class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
