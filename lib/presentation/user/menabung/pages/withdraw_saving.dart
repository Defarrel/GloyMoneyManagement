import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/withdrawSaving/withdraw_saving_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/withdrawSaving/withdraw_saving_event.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/withdrawSaving/withdraw_saving_state.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/done_page.dart';

class WithdrawSaving extends StatefulWidget {
  final int savingId;
  final int userId;

  const WithdrawSaving({super.key, required this.savingId, required this.userId});

  @override
  State<WithdrawSaving> createState() => _WithdrawSavingState();
}

class _WithdrawSavingState extends State<WithdrawSaving> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  late final WithdrawSavingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = WithdrawSavingBloc(SavingRepository(ServiceHttpClient()));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null) return;
    _bloc.add(SubmitWithdrawSaving(
      savingId: widget.savingId,
      userId: widget.userId,
      amount: amount,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: const CustomAppBar(title: "Tarik Tabungan", showLogo: false),
        backgroundColor: const Color(0xFFF4F6F8),
        body: BlocConsumer<WithdrawSavingBloc, WithdrawSavingState>(
          listener: (context, state) {
            if (state is WithdrawSavingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is WithdrawSavingSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DonePage()),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is WithdrawSavingLoading;
            return Padding(
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
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary800,
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isLoading ? 'Mengirim...' : 'Tarik Dana',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
