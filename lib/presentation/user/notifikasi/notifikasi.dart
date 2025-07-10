import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/response/invite/invt_response_model.dart';
import 'package:gloymoneymanagement/data/repository/invitation_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class Notifikasi extends StatefulWidget {
  const Notifikasi({super.key});

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  final _invitationRepo = InvitationRepository(ServiceHttpClient());
  List<InvtResponseModel> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final result = await _invitationRepo.getUserInvitations();
    result.fold(
      (err) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))),
      (data) => setState(() {
        _notifications = data;
        _isLoading = false;
      }),
    );
  }

  Future<void> _respondToInvitation(int id, String status) async {
    final result = await _invitationRepo.respondToInvitation(
      invitationId: id,
      status: status,
    );
    result.fold(
      (err) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))),
      (msg) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
        _loadNotifications();
      },
    );
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text("Tidak ada notifikasi."))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _notifications.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final notif = _notifications[index];
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
                                  icon: const Icon(Icons.check_circle, color: Colors.green),
                                  onPressed: () => _respondToInvitation(notif.id, "accepted"),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () => _respondToInvitation(notif.id, "rejected"),
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
                ),
    );
  }
}
