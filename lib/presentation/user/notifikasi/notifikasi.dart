import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/response/invite/invt_response_model.dart';
import 'package:gloymoneymanagement/data/repository/invitation_repository.dart';
import 'package:gloymoneymanagement/presentation/user/notifikasi/bloc/notifikasi_bloc.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class Notifikasi extends StatelessWidget {
  const Notifikasi({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          NotifikasiBloc(InvitationRepository(ServiceHttpClient()))
            ..add(LoadNotifikasiEvent()),
      child: const NotifikasiView(),
    );
  }
}

class NotifikasiView extends StatelessWidget {
  const NotifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            letterSpacing: 1,
          ),
        ),
      ),
      body: BlocConsumer<NotifikasiBloc, NotifikasiState>(
        listener: (context, state) {
          if (state is NotifikasiError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is NotifikasiResponded) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is NotifikasiLoading || state is NotifikasiInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotifikasiLoaded) {
            if (state.notifications.isEmpty) {
              return const Center(child: Text("Tidak ada notifikasi."));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.notifications.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final notif = state.notifications[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primary200,
                    child: Icon(Icons.person, color: AppColors.primary800),
                  ),
                  title: Text("Undangan dari ${notif.senderName}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tabungan: ${notif.savingTitle}"),
                      Text("Status: ${notif.status}"),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: notif.status == "pending"
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                context.read<NotifikasiBloc>().add(
                                  RespondInvitationEvent(
                                    id: notif.id,
                                    status: "accepted",
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                context.read<NotifikasiBloc>().add(
                                  RespondInvitationEvent(
                                    id: notif.id,
                                    status: "rejected",
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Text(
                          notif.status.toUpperCase(),
                          style: TextStyle(
                            color: notif.status == "accepted"
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                );
              },
            );
          }

          return const Center(child: Text("Terjadi kesalahan."));
        },
      ),
    );
  }
}
