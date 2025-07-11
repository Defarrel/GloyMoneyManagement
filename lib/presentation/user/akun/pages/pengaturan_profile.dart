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
  String? _role;
  bool _isSaving = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDataFromApi();
  }

  Future<void> _loadUserDataFromApi() async {
    final result = await _akunRepository.getCurrentUser();
    result.fold(
      (error) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $error")));
        }
        setState(() => _isLoading = false);
      },
      (user) {
        setState(() {
          _userId = user.id;
          _role = user.role;
          _nameController.text = user.name;
          _emailController.text = user.email;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _saveProfileData() async {
    if (!_formKey.currentState!.validate() || _userId == null || _role == null)
      return;

    setState(() => _isSaving = true);

    final request = AkunRequestModel(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      role: _role!,
    );

    final result = await _akunRepository.updateAkun(_userId!, request);

    result.fold(
      (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $error")));
        }
      },
      (data) async {
        await _storage.write(key: 'userName', value: data.name);
        await _storage.write(key: 'userEmail', value: data.email);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profil berhasil diperbarui")),
          );
          Navigator.pop(context, true);
        }
      },
    );

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Pengaturan Profil", showLogo: false),
      backgroundColor: const Color(0xFFF4F6F8),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
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
