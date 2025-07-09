import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/bloc/withdraw_pensiun/withdrawpensiun_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/done_page.dart';

class WithdrawPensiun extends StatefulWidget {
  const WithdrawPensiun({super.key});

  @override
  State<WithdrawPensiun> createState() => _WithdrawPensiunState();
}

class _WithdrawPensiunState extends State<WithdrawPensiun> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WithdrawpensiunBloc(),
      child: Scaffold(
        appBar: const CustomAppBar(title: "Tarik Dana Pensiun", showLogo: false),
        backgroundColor: const Color(0xFFF4F6F8),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: BlocConsumer<WithdrawpensiunBloc, WithdrawpensiunState>(
              listener: (context, state) {
                if (state is WithdrawpensiunSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Berhasil menarik dana")),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DonePage()),
                  );
                } else if (state is WithdrawpensiunFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is WithdrawpensiunLoading;

                return Column(
                  children: [
                    CustomTextField2(
                      controller: _amountController,
                      label: "Jumlah Penarikan (Rp)",
                      keyboardType: TextInputType.number,
                      validator: "Jumlah tidak boleh kosong",
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final amount = int.tryParse(_amountController.text);
                                if (amount != null) {
                                  context
                                      .read<WithdrawpensiunBloc>()
                                      .add(SubmitWithdrawPensiun(amount));
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
                        isLoading ? 'Mengirim...' : 'Tarik Dana',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
