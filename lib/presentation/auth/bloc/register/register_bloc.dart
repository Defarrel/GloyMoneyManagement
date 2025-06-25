import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/repository/auth_repository.dart';
import 'package:gloymoneymanagement/presentation/auth/bloc/register/register_event.dart';
import 'package:gloymoneymanagement/presentation/auth/bloc/register/register_state.dart';


class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(RegisterLoading());

      final result = await authRepository.register(event.requestModel);
      result.fold(
        (error) => emit(RegisterFailure(error)),
        (_) => emit(RegisterSuccess()),
      );
    });
  }
}
