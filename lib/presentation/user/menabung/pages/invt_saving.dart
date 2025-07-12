import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/response/akun/akun_response_model.dart';
import 'package:gloymoneymanagement/data/repository/akun_repository.dart';
import 'package:gloymoneymanagement/data/repository/invitation_repository.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/invtSaving/invt_saving_bloc.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/invtSaving/invt_saving_event.dart';
import 'package:gloymoneymanagement/presentation/user/menabung/bloc/invtSaving/invt_saving_state.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class InvtSaving extends StatefulWidget {
  final int savingId;

  const InvtSaving({super.key, required this.savingId});

  @override
  State<InvtSaving> createState() => _InvtSavingState();
}

class _InvtSavingState extends State<InvtSaving> {
  late final InvtSavingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = InvtSavingBloc(
      akunRepository: AkunRepository(ServiceHttpClient()),
      invitationRepository: InvitationRepository(ServiceHttpClient()),
    )..add(LoadUsers());
  }

  Future<void> _confirmInvite(AkunResponseModel user, int senderId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: Text("Apakah Anda yakin ingin mengundang ${user.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary800,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ya, Undang", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _bloc.add(SendInvitation(
        savingId: widget.savingId,
        receiverId: user.id!,
        senderId: senderId,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F8),
        appBar: CustomAppBar(title: "Undang Teman", showLogo: true),
        body: BlocConsumer<InvtSavingBloc, InvtSavingState>(
          listener: (context, state) {
            if (state is InvtSavingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is InvtSavingSuccessMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is InvtSavingLoading || state is InvtSavingInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InvtSavingLoaded) {
              final users = state.users;
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary200,
                      child: Icon(Icons.person, color: AppColors.primary800),
                    ),
                    title: Text(user.name ?? "-"),
                    subtitle: Text(user.email ?? ""),
                    trailing: OutlinedButton(
                      onPressed: () => _confirmInvite(user, state.currentUserId),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                      ),
                      child: const Text(
                        "Undang",
                        style: TextStyle(color: AppColors.primary800),
                      ),
                    ),
                  );
                },
              );
            } else if (state is InvtSavingError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const Center(child: Text("Tidak ada data"));
            }
          },
        ),
      ),
    );
  }
}
