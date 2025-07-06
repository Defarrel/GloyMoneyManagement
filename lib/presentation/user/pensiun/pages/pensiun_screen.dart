import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/response/pensiun/pensiun_response_model.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/pages/main_pensiun.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/pages/tambah_pensiun.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class PensiunScreen extends StatefulWidget {
  const PensiunScreen({super.key});

  @override
  State<PensiunScreen> createState() => _PensiunScreenState();
}

class _PensiunScreenState extends State<PensiunScreen> {
  final _repo = PensionRepository(ServiceHttpClient());
  bool _isLoading = true;
  PensionResponseModel? _pension;

  @override
  void initState() {
    super.initState();
    _fetchPensionData();
  }

  Future<void> _fetchPensionData() async {
    setState(() => _isLoading = true);
    final result = await _repo.getPension();
    result.fold(
      (err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
        setState(() => _isLoading = false);
      },
      (data) {
        setState(() {
          _pension = data;
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: CustomAppBar(
        title: "Dana Pensiun",
        showLogo: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pension == null
              ? _buildEmptyView()
              : MainPensiun(pension: _pension!, onRefresh: _fetchPensionData),
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
                ).then((_) => _fetchPensionData());
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
