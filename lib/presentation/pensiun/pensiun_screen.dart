import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/presentation/pensiun/bloc/main_pensiun/mainpensiun_bloc.dart';
import 'package:gloymoneymanagement/presentation/pensiun/main_pensiun.dart';
import 'package:gloymoneymanagement/presentation/pensiun/tambah_pensiun.dart';

class PensiunScreen extends StatelessWidget {
  const PensiunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainpensiunBloc()..add(FetchMainPensiun()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F8),
        appBar: CustomAppBar(title: "Dana Pensiun", showLogo: true),
        body: BlocBuilder<MainpensiunBloc, MainpensiunState>(
          builder: (context, state) {
            if (state is MainpensiunLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MainpensiunLoaded) {
              if (state.pension != null) {
                return const MainPensiun();
              } else {
                return _buildEmptyView(context);
              }
            }

            if (state is MainpensiunError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox(); // fallback
          },
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.hourglass_empty, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Belum ada Dana Pensiun',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Yuk mulai rencanakan pensiun kamu dari sekarang!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TambahPensiun()),
                ).then((_) {
                  context.read<MainpensiunBloc>().add(FetchMainPensiun());
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text(
                'Tambah Dana Pensiun',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
