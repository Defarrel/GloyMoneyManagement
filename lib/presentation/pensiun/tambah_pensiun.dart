import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/presentation/pensiun/bloc/tambah_pensiun/tambahpensiun_bloc.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class TambahPensiun extends StatefulWidget {
  const TambahPensiun({super.key});

  @override
  State<TambahPensiun> createState() => _TambahPensiunState();
}

class _TambahPensiunState extends State<TambahPensiun> {
  final _formKey = GlobalKey<FormState>();
  final _targetController = TextEditingController();
  final _deadlineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TambahpensiunBloc(PensionRepository(ServiceHttpClient())),
      child: BlocListener<TambahpensiunBloc, TambahpensiunState>(
        listener: (context, state) {
          if (state is DeadlinePicked) {
            _deadlineController.text = state.deadline;
          } else if (state is TambahpensiunSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            Navigator.pop(context);
          } else if (state is TambahpensiunFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Scaffold(
          appBar: const CustomAppBar(
            title: "Tambah Dana Pensiun",
            showLogo: false,
          ),
          backgroundColor: const Color(0xFFF4F6F8),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField2(
                    controller: _targetController,
                    label: "Target Dana (Rp)",
                    keyboardType: TextInputType.number,
                    validator: "Target tidak boleh kosong",
                  ),
                  const SizedBox(height: 16),
                  CustomTextField2(
                    controller: _deadlineController,
                    label: "Deadline",
                    readOnly: true,
                    onTap: () => context.read<TambahpensiunBloc>().add(
                      SelectDeadline(context),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                    validator: "Deadline wajib diisi",
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<TambahpensiunBloc, TambahpensiunState>(
                    builder: (context, state) {
                      final isLoading = state is TambahpensiunLoading;
                      return ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  final target = int.tryParse(
                                    _targetController.text,
                                  );
                                  if (target != null) {
                                    context.read<TambahpensiunBloc>().add(
                                      SubmitTambahPensiun(
                                        targetAmount: target,
                                        deadline: _deadlineController.text,
                                      ),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary800,
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isLoading ? 'Menyimpan...' : 'Simpan Dana Pensiun',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
