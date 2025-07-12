import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/repository/menabung_repository.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/topUpSaving/top_up_saving_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/topUpSaving/top_up_saving_event.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/topUpSaving/top_up_saving_state.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/done_page.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

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
  late final TopUpSavingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = TopUpSavingBloc(SavingRepository(ServiceHttpClient()));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null) return;
    _bloc.add(SubmitTopUpSaving(
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
        appBar: const CustomAppBar(title: "Top Up Tabungan", showLogo: false),
        backgroundColor: const Color(0xFFF4F6F8),
        body: BlocConsumer<TopUpSavingBloc, TopUpSavingState>(
          listener: (context, state) {
            if (state is TopUpSavingFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            } else if (state is TopUpSavingSuccess) {
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
            final isLoading = state is TopUpSavingLoading;
            return Padding(
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
                      onPressed: isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary800,
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isLoading ? 'Mengirim...' : 'Kirim Top Up',
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
