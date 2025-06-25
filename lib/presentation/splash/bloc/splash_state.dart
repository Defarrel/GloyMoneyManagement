part of 'splash_bloc.dart';

sealed class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {
  final String role;
  SplashAuthenticated(this.role);
}

class SplashUnauthenticated extends SplashState {}
