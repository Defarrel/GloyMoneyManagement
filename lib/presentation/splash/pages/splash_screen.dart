import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/presentation/auth/pages/login_screen.dart';
import 'package:gloymoneymanagement/presentation/home/pages/home_root.dart';
import 'package:gloymoneymanagement/presentation/home/pages/home_screen.dart';
import 'package:gloymoneymanagement/presentation/splash/bloc/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashBloc(secureStorage: const FlutterSecureStorage())..add(CheckSplashToken()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeRoot()),
            );
          } else if (state is SplashUnauthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        },
        child: const _SplashUI(),
      ),
    );
  }
}

class _SplashUI extends StatelessWidget {
  const _SplashUI();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('lib/core/assets/images/logo_polos.png'),
          width: 150,
        ),
      ),
    );
  }
}
