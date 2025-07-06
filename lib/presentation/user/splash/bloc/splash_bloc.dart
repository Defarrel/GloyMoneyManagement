import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FlutterSecureStorage secureStorage;

  SplashBloc({required this.secureStorage}) : super(SplashInitial()) {
    on<CheckSplashToken>(_onCheckSplashToken);
  }

  Future<void> _onCheckSplashToken(
    CheckSplashToken event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2));

    final token = await secureStorage.read(key: "authToken");
    final role = await secureStorage.read(key: "userRole");

    if (token != null && role != null) {
      emit(SplashAuthenticated(role));
    } else {
      emit(SplashUnauthenticated());
    }
  }
}
