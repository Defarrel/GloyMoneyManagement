import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/bloc/main_pensiun/mainpensiun_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/pages/main_pensiun.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/pages/tambah_pensiun.dart';

class PensiunScreen extends StatefulWidget {
  const PensiunScreen({super.key});

  @override
  State<PensiunScreen> createState() => _PensiunScreenState();
}

class _PensiunScreenState extends State<PensiunScreen> {
  late MainpensiunBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MainpensiunBloc()..add(FetchMainPensiun());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: CustomAppBar(
        title: "Dana Pensiun",
        showLogo: true,
      ),
      body: BlocProvider.value(
        value: _bloc,
        child: BlocBuilder<MainpensiunBloc, MainpensiunState>(
          builder: (context, state) {
            if (state is MainpensiunLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MainpensiunLoaded) {
              return const MainPensiun();
            } else if (state is MainpensiunError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return _buildEmptyView();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
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
                ).then((_) => _bloc.add(FetchMainPensiun()));
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
