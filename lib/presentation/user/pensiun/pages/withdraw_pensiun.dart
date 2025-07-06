import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/request/pensiun/pensiun_amount_request_model.dart.dart';
import 'package:gloymoneymanagement/data/repository/pensiun_repository.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/done_page.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class WithdrawPensiun extends StatefulWidget {
  const WithdrawPensiun({super.key});

  @override
  State<WithdrawPensiun> createState() => _WithdrawPensiunState();
}

class _WithdrawPensiunState extends State<WithdrawPensiun> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _repo = PensionRepository(ServiceHttpClient());
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final model = PensiunAmountRequestModel(
      amount: int.parse(_amountController.text),
    );

    final result = await _repo.withdrawPension(model);
    result.fold(
      (err) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(err))),
      (msg) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        Navigator.push(
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
      appBar: const CustomAppBar(title: "Tarik Dana Pensiun", showLogo: false),
      backgroundColor: const Color(0xFFF4F6F8),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField2(
                controller: _amountController,
                label: "Jumlah Penarikan (Rp)",
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
                  _isLoading ? 'Mengirim...' : 'Tarik Dana',
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
