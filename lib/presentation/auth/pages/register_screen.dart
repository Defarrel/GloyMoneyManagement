import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field.dart';
import 'package:gloymoneymanagement/core/components/spaces.dart';
import 'package:gloymoneymanagement/data/models/request/auth/register_request_model.dart';
import 'package:gloymoneymanagement/data/repository/auth_repository.dart';
import 'package:gloymoneymanagement/presentation/auth/pages/login_screen.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authRepository = AuthRepository(ServiceHttpClient());

  bool isLoading = false;
  bool isShowPassword = false;
  String? errorMessage;

  void handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final request = RegisterRequestModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final result = await authRepository.register(request);

    result.fold(
      (error) {
        setState(() {
          errorMessage = error;
          isLoading = false;
        });
      },
      (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pendaftaran berhasil!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 16, 71, 24), 
              Color.fromARGB(255, 8, 210, 156), 
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SpaceHeight(80),
                Image.asset(
                  'lib/core/assets/images/logo.png',
                  width: 120,
                  height: 120,
                ),
                const SpaceHeight(10),
                Text(
                  'Daftar Akun GMM',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceHeight(32),
                if (errorMessage != null)
                  Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                const SpaceHeight(12),
                CustomTextField(
                  controller: nameController,
                  label: 'Nama Lengkap',
                  validator: 'Nama wajib diisi',
                  prefixIcon: const Icon(Icons.person),
                ),
                const SpaceHeight(20),
                CustomTextField(
                  controller: emailController,
                  label: 'Email',
                  validator: 'Email wajib diisi',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email),
                ),
                const SpaceHeight(20),
                CustomTextField(
                  controller: passwordController,
                  label: 'Password',
                  validator: 'Password wajib diisi',
                  obscureText: !isShowPassword,
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isShowPassword = !isShowPassword;
                      });
                    },
                    icon: Icon(
                      isShowPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                const SpaceHeight(32),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: AppColors.primary)
                        : const Text("Daftar", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SpaceHeight(20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Sudah punya akun? Masuk",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
