import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/presentation/user/pensiun/bloc/topup_pensiun/topuppensiun_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/done_page.dart';

class TopUpPensiun extends StatefulWidget {
  const TopUpPensiun({super.key});

  @override
  State<TopUpPensiun> createState() => _TopUpPensiunState();
}

class _TopUpPensiunState extends State<TopUpPensiun> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TopupPensiunBloc(),
      child: Scaffold(
        appBar: const CustomAppBar(title: "Top Up Dana Pensiun", showLogo: false),
        backgroundColor: const Color(0xFFF4F6F8),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: BlocConsumer<TopupPensiunBloc, TopupPensiunState>(
              listener: (context, state) {
                if (state is TopupPensiunFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is TopupPensiunSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Top up berhasil")),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DonePage()),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is TopupPensiunLoading;

                return Column(
                  children: [
                    CustomTextField2(
                      controller: _amountController,
                      label: "Jumlah Top Up (Rp)",
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
                                  context.read<TopupPensiunBloc>().add(
                                        SubmitTopupPensiun(amount),
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
                        isLoading ? 'Mengirim...' : 'Kirim Top Up',
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
