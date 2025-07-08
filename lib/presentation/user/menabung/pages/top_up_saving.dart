import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/request/menabung/join_menabung_request_model.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart'; 
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/done_page.dart';

class TopUpSaving extends StatefulWidget {
  final int savingId;
  final int userId;

  const TopUpSaving({super.key, required this.savingId, required this.userId});

  @override
  State<TopUpSaving> createState() => _TopUpSavingState();
}

class _TopUpSavingState extends State<TopUpSaving> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _repo = SavingRepository(ServiceHttpClient());
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final request = JointSavingRequestModel(
      userId: widget.userId,
      amount: int.parse(_amountController.text),
    );

    final result = await _repo.contributeToSaving(widget.savingId, request);
    result.fold(
      (err) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(err))),
      (msg) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DonePage()),
        );
      },
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Top Up Tabungan", showLogo: false),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField2(
                controller: _amountController,
                label: "Jumlah Top Up (Rp)",
                keyboardType: TextInputType.number,
                validator: "Jumlah tidak boleh kosong",
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary800,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isLoading ? 'Mengirim...' : 'Kirim Top Up',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
