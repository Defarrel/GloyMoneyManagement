import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field.dart';
import 'package:gloymoneymanagement/core/components/spaces.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/request/auth/register_request_model.dart';
import 'package:gloymoneymanagement/presentation/user/auth/bloc/register/register_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/auth/bloc/register/register_event.dart';
import 'package:gloymoneymanagement/presentation/user/auth/bloc/register/register_state.dart';
import 'package:gloymoneymanagement/presentation/user/auth/pages/login_screen.dart';

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
  bool isShowPassword = false;

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
                Image.asset('lib/core/assets/images/logo.png', width: 120, height: 120),
                const SpaceHeight(10),
                Text(
                  'Daftar Akun GMM',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SpaceHeight(32),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if (state is RegisterFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    } else if (state is RegisterSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Pendaftaran berhasil!")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
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
                            onPressed: () =>
                                setState(() => isShowPassword = !isShowPassword),
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
                            onPressed: state is RegisterLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      final request = RegisterRequestModel(
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                        role: "user",
                                      );
                                      context.read<RegisterBloc>().add(
                                            RegisterRequested(requestModel: request),
                                          );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary800,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is RegisterLoading
                                ? const CircularProgressIndicator(color: AppColors.primary)
                                : const Text("Daftar", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SpaceHeight(20),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
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