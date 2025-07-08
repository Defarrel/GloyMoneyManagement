import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/request/menabung/menabung_request_model.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
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
  final _repository = SavingRepository(ServiceHttpClient());
  final _storage = const FlutterSecureStorage();

  DateTime? _selectedDeadline;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
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

    setState(() => _isSaving = true);

    final userIdStr = await _storage.read(key: 'userId');
    final userId = int.tryParse(userIdStr ?? '');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID tidak ditemukan")),
      );
      setState(() => _isSaving = false);
      return;
    }

    final model = SavingRequestModel(
      userId: userId,
      title: _titleController.text.trim(),
      targetAmount: int.parse(_targetController.text.trim()),
      deadline: _selectedDeadline!.toIso8601String(),
    );

    final result = await _repository.createSaving(model);

    setState(() => _isSaving = false);

    result.fold(
      (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menambahkan tabungan: $error")),
        );
      },
      (successMessage) {
        Navigator.pop(context, true); // Kirim true agar halaman sebelumnya tahu berhasil
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: const CustomAppBar(title: "Tambah Tabungan", showLogo: false),
      body: Padding(
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
              ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
