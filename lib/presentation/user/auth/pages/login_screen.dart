import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/core/components/spaces.dart';
import 'package:gloymoneymanagement/data/models/request/auth/login_request_model.dart';
import 'package:gloymoneymanagement/presentation/advisor/home/pages/home_screen.dart';
import 'package:gloymoneymanagement/presentation/user/auth/bloc/login/login_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/home/pages/home_root.dart';
import 'package:gloymoneymanagement/presentation/user/auth/pages/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0E4316), Color(0xFF07AB7F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SpaceHeight(80),
                          Image.asset(
                            'lib/core/assets/images/logo.png',
                            width: 120,
                          ),
                          const SpaceHeight(16),
                          Text(
                            'Selamat Datang Kembali',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SpaceHeight(8),
                          Text(
                            'Masuk untuk mulai mengelola keuangan',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SpaceHeight(32),
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            validator: 'Email wajib diisi',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email),
                          ),
                          const SpaceHeight(20),
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            validator: 'Password wajib diisi',
                            obscureText: !isShowPassword,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () => setState(
                                () => isShowPassword = !isShowPassword,
                              ),
                              icon: Icon(
                                isShowPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                          const SpaceHeight(32),
                          BlocConsumer<LoginBloc, LoginState>(
                            listener: (context, state) {
                              if (state is LoginFailure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error)),
                                );
                              } else if (state is LoginSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Selamat datang, ${state.responseModel.user?.name ?? ''}',
                                    ),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                                final role = state.responseModel.user?.role;
                                if (role == 'advisor') {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const HomeScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomeRoot(),
                                    ),
                                  );
                                }
                              }
                            },
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: state is LoginLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final request = LoginRequestModel(
                                              email: _emailController.text
                                                  .trim(),
                                              password: _passwordController.text
                                                  .trim(),
                                            );
                                            context.read<LoginBloc>().add(
                                              LoginRequested(
                                                requestModel: request,
                                              ),
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
                                  child: state is LoginLoading
                                      ? const CircularProgressIndicator(
                                          color: AppColors.primary,
                                        )
                                      : const Text(
                                          "Masuk",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SpaceHeight(20),
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            ),
                            child: const Text(
                              'Belum punya akun? Daftar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SpaceHeight(16), // Tambahan padding bawah
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
