import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/data/models/response/akun/akun_response_model.dart';
import 'package:gloymoneymanagement/data/repository/advisor_repository.dart';
import 'package:gloymoneymanagement/data/repository/akun_repository.dart';
import 'package:gloymoneymanagement/presentation/advisor/home/pages/detail_tabungan_user.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class HomeScreenAdvisor extends StatefulWidget {
  const HomeScreenAdvisor({super.key});

  @override
  State<HomeScreenAdvisor> createState() => _HomeScreenAdvisorState();
}

class _HomeScreenAdvisorState extends State<HomeScreenAdvisor> {
  final _searchController = TextEditingController();
  final AkunRepository _akunRepo = AkunRepository(ServiceHttpClient());
  final AdvisorRepository _advisorRepo = AdvisorRepository(ServiceHttpClient());

  List<AkunResponseModel> _users = [];
  List<AkunResponseModel> _filtered = [];
  bool _loading = true;

  Map<int, String> _requestStatus = {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => _onSearch(_searchController.text));
    _loadUsers();
    _loadRequests();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    final res = await _akunRepo.getAllUsers();
    res.fold(
      (err) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(err))),
      (list) {
        _users = list;
        _filtered = list;
      },
    );
    setState(() => _loading = false);
  }

  Future<void> _loadRequests() async {
    try {
      final requests = await _advisorRepo.getMyRequests();
      setState(() {
        for (var r in requests) {
          _requestStatus[r.userId] = r.status;
        }
      });
    } catch (e) {
      debugPrint("Failed to load advisor requests: $e");
    }
  }

  void _onSearch(String q) {
    final tx = q.toLowerCase();
    setState(() {
      _filtered = _users.where((u) {
        return u.name.toLowerCase().contains(tx) ||
            u.email.toLowerCase().contains(tx);
      }).toList();
    });
  }

  Future<void> _requestAccess(int userId) async {
    try {
      await _advisorRepo.requestAccess(userId);
      setState(() {
        _requestStatus[userId] = 'PENDING';
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal minta akses")));
    }
  }

  Widget _item(AkunResponseModel u) {
    final status = _requestStatus[u.id ?? -1]; 
    final isPending = status == 'PENDING';
    final isAccepted = status == 'ACCEPTED';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  u.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(u.email, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: isPending
                ? null
                : isAccepted
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DetailTabunganUser(),
                      ),
                    );
                  }
                : () => _requestAccess(u.id!),
            style: ElevatedButton.styleFrom(
              backgroundColor: isAccepted
                  ? Colors.green
                  : isPending
                  ? Colors.orange
                  : null,
            ),
            child: Text(
              isAccepted
                  ? 'Lihat Detail'
                  : isPending
                  ? 'Menunggu'
                  : 'Minta Akses',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: const CustomAppBar(title: "Advisor Dashboard", showLogo: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari user...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _filtered.isEmpty
                ? const Center(child: Text("Tidak ada user"))
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _item(_filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}
