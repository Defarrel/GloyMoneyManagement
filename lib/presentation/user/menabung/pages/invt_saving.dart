import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/data/models/request/invite/invt_request_model.dart';
import 'package:gloymoneymanagement/data/models/response/akun/akun_response_model.dart';
import 'package:gloymoneymanagement/data/repository/akun_repository.dart';
import 'package:gloymoneymanagement/data/repository/invitation_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class InvtSaving extends StatefulWidget {
  final int savingId;

  const InvtSaving({super.key, required this.savingId});

  @override
  State<InvtSaving> createState() => _InvtSavingState();
}

class _InvtSavingState extends State<InvtSaving> {
  final _userRepo = AkunRepository(ServiceHttpClient());
  final _invtRepo = InvitationRepository(ServiceHttpClient());

  List<AkunResponseModel> _users = [];
  bool _isLoading = true;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final userId = await _userRepo.getUserIdFromStorage();
    setState(() {
      _currentUserId = userId;
    });
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final result = await _userRepo.getAllUsers();
    result.fold(
      (err) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(err))),
      (data) => setState(() {
        _users = data
            .where((user) => user.id != _currentUserId)
            .toList(); // tidak tampilkan diri sendiri
        _isLoading = false;
      }),
    );
  }

  Future<void> _confirmInvite(AkunResponseModel user) async {
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
      final result = await _invtRepo.sendInvitation(
        InvtRequestModel(
          savingId: widget.savingId,
          receiverId: user.id!,
          senderId: _currentUserId!, // ← sudah diperoleh dari secure storage
        ),
      );

      result.fold(
        (err) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err))),
        (msg) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: CustomAppBar(title: "Undang Teman", showLogo: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.primary200,
                    child: Icon(Icons.person, color: AppColors.primary800),
                  ),
                  title: Text(user.name ?? "-"),
                  subtitle: Text(user.email ?? ""),
                  trailing: OutlinedButton(
                    onPressed: () => _confirmInvite(user),
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
            ),
    );
  }
}
