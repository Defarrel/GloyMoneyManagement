import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/repository/auth_repository.dart';
import 'package:gloymoneymanagement/presentation/auth/bloc/login/login_bloc.dart';
import 'package:gloymoneymanagement/presentation/auth/bloc/register/register_bloc.dart';
import 'package:gloymoneymanagement/presentation/splash/pages/splash_screen.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              LoginBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) =>
              RegisterBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
      ],
      child: MaterialApp(
        title: 'GMM App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        home: const SplashScreen(),
      ),
    );
  }
}
