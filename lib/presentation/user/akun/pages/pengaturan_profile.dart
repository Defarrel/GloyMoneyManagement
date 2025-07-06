import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field.dart';
import 'package:gloymoneymanagement/core/components/spaces.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/request/akun/akun_request_model.dart';
import 'package:gloymoneymanagement/data/repository/akun_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class PengaturanProfile extends StatefulWidget {
  const PengaturanProfile({super.key});

  @override
  State<PengaturanProfile> createState() => _PengaturanProfileState();
}

class _PengaturanProfileState extends State<PengaturanProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  final AkunRepository _akunRepository = AkunRepository(ServiceHttpClient());

  int? _userId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final idStr = await _storage.read(key: 'userId');
    final name = await _storage.read(key: 'userName') ?? '';
    final email = await _storage.read(key: 'userEmail') ?? '';

    setState(() {
      _userId = int.tryParse(idStr ?? '');
      _nameController.text = name;
      _emailController.text = email;
    });
  }

  Future<void> _saveProfileData() async {
    if (!_formKey.currentState!.validate() || _userId == null) return;

    setState(() => _isSaving = true);

    final role = await _storage.read(key: 'userRole') ?? '';
    final request = AkunRequestModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      role: role,
    );

    final result = await _akunRepository.updateAkun(_userId!, request);

    result.fold(
      (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal menyimpan: $error")),
          );
        }
      },
      (data) async {
        await _storage.write(key: 'userName', value: data.name);
        await _storage.write(key: 'userEmail', value: data.email);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profil berhasil diperbarui")),
          );
          Navigator.pop(context);
        }
      },
    );

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "Pengaturan Profil", showLogo: false),
      backgroundColor: const Color(0xFFF4F6F8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceHeight(8),
              CustomTextField(
                controller: _nameController,
                label: "Nama Lengkap",
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.person),
                validator: 'Nama wajib diisi',
              ),
              const SpaceHeight(20),
              CustomTextField(
                controller: _emailController,
                label: "Email",
                labelStyle: const TextStyle(color: Colors.black),
                prefixIcon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: 'Email wajib diisi',
              ),
              const SpaceHeight(40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfileData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan Perubahan',
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
