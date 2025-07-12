import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/data/repository/auth_repository.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/presentation/user/auth/bloc/login/login_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/auth/bloc/register/register_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/bloc/main_pensiun/mainpensiun_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/bloc/tambah_pensiun/tambahpensiun_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/bloc/topup_pensiun/topuppensiun_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/bloc/withdraw_pensiun/withdrawpensiun_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/splash/pages/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/bloc/detailTransaksi/detail_transaksi_bloc.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //Auth
        BlocProvider(
          create: (_) =>
              LoginBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) =>
              RegisterBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),

        BlocProvider(
          create: (_) => DetailTransaksiBloc(
            repository: TransactionRepository(ServiceHttpClient()),
          ),
        ),

        //Pensiun
        BlocProvider(create: (_) => MainpensiunBloc()..add(FetchMainPensiun())),
        BlocProvider(
          create: (_) =>
              TambahpensiunBloc(PensionRepository(ServiceHttpClient())),
        ),
      ],
      child: MaterialApp(
        title: 'GMM App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            primary: Colors.green,
            secondary: Colors.greenAccent,
          ),
        ),
        home: const SplashScreen(),

        supportedLocales: const [Locale('id', 'ID'), Locale('en', 'US')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    );
  }
}
