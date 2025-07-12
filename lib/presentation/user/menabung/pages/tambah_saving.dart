import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/tambahSaving/tambah_saving_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/tambahSaving/tambah_saving_event.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/tambahSaving/tambah_saving_state.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TambahSavingPage extends StatefulWidget {
  const TambahSavingPage({super.key});

  @override
  State<TambahSavingPage> createState() => _TambahSavingPageState();
}

class _TambahSavingPageState extends State<TambahSavingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  DateTime? _selectedDeadline;

  late TambahSavingBloc _bloc;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _bloc = TambahSavingBloc(SavingRepository(ServiceHttpClient()));
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
        _deadlineController.text = DateFormat(
          'EEEE, dd MMMM yyyy',
          'id_ID',
        ).format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDeadline == null) return;

    final userIdStr = await _storage.read(key: 'userId');
    final userId = int.tryParse(userIdStr ?? '');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID tidak ditemukan")),
      );
      return;
    }

    _bloc.add(SubmitSavingEvent(
      userId: userId,
      title: _titleController.text.trim(),
      targetAmount: int.parse(_targetController.text.trim()),
      deadline: _selectedDeadline!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F8),
        appBar: const CustomAppBar(title: "Tambah Tabungan", showLogo: false),
        body: BlocListener<TambahSavingBloc, TambahSavingState>(
          listener: (context, state) {
            if (state is TambahSavingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Gagal menambahkan tabungan: ${state.message}")),
              );
            } else if (state is TambahSavingSuccess) {
              Navigator.pop(context, true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Tabungan berhasil ditambahkan")),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  CustomTextField2(
                    controller: _titleController,
                    label: 'Judul Tabungan',
                    validator: 'Judul wajib diisi',
                  ),
                  const SizedBox(height: 16),
                  CustomTextField2(
                    controller: _targetController,
                    label: 'Target Nominal',
                    keyboardType: TextInputType.number,
                    validator: 'Nominal wajib diisi',
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickDeadline,
                    child: AbsorbPointer(
                      child: CustomTextField2(
                        controller: _deadlineController,
                        label: 'Deadline Tabungan',
                        validator: 'Deadline wajib dipilih',
                        suffixIcon: const Icon(Icons.calendar_today),
                        readOnly: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<TambahSavingBloc, TambahSavingState>(
                    builder: (context, state) {
                      final isLoading = state is TambahSavingLoading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Simpan',
                                style: TextStyle(fontSize: 16, color: Colors.white),
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