import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/components/spaces.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/repository/akun_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class GantiPassword extends StatefulWidget {
  const GantiPassword({super.key});

  @override
  State<GantiPassword> createState() => _GantiPasswordState();
}

class _GantiPasswordState extends State<GantiPassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _storage = const FlutterSecureStorage();
  final _repo = AkunRepository(ServiceHttpClient());

  bool _isLoading = false;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await _repo.getUserIdFromStorage();
    setState(() => _userId = id);
  }

  Future<void> _gantiPassword() async {
    if (!_formKey.currentState!.validate() || _userId == null) return;

    FocusScope.of(context).unfocus(); // Tutup keyboard
    setState(() => _isLoading = true);

    final result = await _repo.updatePassword(
      _userId!,
      _passwordController.text.trim(),
    );

    result.fold(
      (err) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Gagal: $err"))),
      (msg) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(msg)));
        Navigator.pop(context, true);
      },
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Ganti Password", showLogo: false),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField2(
                controller: _passwordController,
                label: "Password Baru",
                validator: 'Password tidak boleh kosong',
              ),
              const SpaceHeight(20),
              CustomTextField2(
                controller: _confirmController,
                label: "Konfirmasi Password",
                validator: 'Konfirmasi password wajib diisi',
              ),
              const SpaceHeight(40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _gantiPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan Password Baru',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
