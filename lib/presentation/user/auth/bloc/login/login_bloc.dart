import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/models/request/auth/login_request_model.dart';
import 'package:gloymoneymanagement/data/models/response/auth/auth_response_mode.dart';
import 'package:gloymoneymanagement/data/repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await authRepository.login(event.requestModel);

    result.fold(
      (error) => emit(LoginFailure(error: error)),
      (response) => emit(LoginSuccess(responseModel: response)),
    );
  }
}
