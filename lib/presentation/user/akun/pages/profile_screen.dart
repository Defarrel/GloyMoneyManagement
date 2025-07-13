import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/data/repository/akun_repository.dart';
import 'package:gloymoneymanagement/presentation/user/akun/pages/camera_page.dart';
import 'package:gloymoneymanagement/presentation/user/akun/pages/pengaturan_profile.dart';
import 'package:gloymoneymanagement/presentation/user/auth/pages/login_screen.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:gloymoneymanagement/services/storage_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AkunRepository _akunRepository = AkunRepository(ServiceHttpClient());

  String _name = 'Memuat...';
  String _email = 'Memuat...';
  File? _profileImage;
  String? _photoUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final imagePath = await _storage.read(key: 'userProfilePath');
    debugPrint('📸 Local image path: $imagePath');

    final result = await _akunRepository.getCurrentUser();
    result.fold(
      (error) {
        setState(() {
          _name = 'Gagal memuat';
          _email = '-';
          _isLoading = false;
        });
      },
      (user) async {
        setState(() {
          _name = user.name;
          _email = user.email;
          _profileImage = imagePath != null ? File(imagePath) : null;
          _photoUrl = user.photoProfile;
          _isLoading = false;
        });

        await _storage.write(key: 'userName', value: user.name);
        await _storage.write(key: 'userEmail', value: user.email);
      },
    );
  }

  Future<void> _saveProfileImage(File imageFile) async {
    final saved = await StorageHelper.saveImage(imageFile, 'profile_');
    await _storage.write(key: 'userProfilePath', value: saved.path);
    setState(() => _profileImage = saved);

    try {
      final userId = await _akunRepository.getUserIdFromStorage();
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mendapatkan ID pengguna")),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final response = await _akunRepository.uploadProfilePhoto(
        userId,
        saved.path,
      );
      Navigator.pop(context); // Tutup loading

      response.fold(
        (error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Upload gagal: $error")));
        },
        (photoUrl) {
          setState(() => _photoUrl = photoUrl);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Foto profil berhasil diunggah")),
          );
        },
      );
    } catch (e) {
      Navigator.pop(context); // Tutup loading
      debugPrint("Upload error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat upload foto")),
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) await _saveProfileImage(File(picked.path));
  }

  Future<void> _takePhoto() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CameraPage()),
    );
    if (result != null && result is File) {
      await _saveProfileImage(result);
    }
  }

  void _showProfileOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 8, 0),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 10,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Ubah Foto Profil"),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        content: const Text("Pilih sumber foto profil Anda."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _takePhoto();
            },
            child: const Text("Kamera"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickImageFromGallery();
            },
            child: const Text("Galeri"),
          ),
          TextButton(
            onPressed: () async {
              await _storage.delete(key: 'userProfilePath');
              await _storage.delete(key: 'userPhotoUrl');
              setState(() {
                _profileImage = null;
                _photoUrl = null;
              });
              Navigator.pop(context);
            },
            child: const Text(
              "Hapus Foto",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah kamu yakin ingin keluar dari akun?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await _storage.deleteAll();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  bool _isValidUrl(String? url) {
    return url != null && Uri.tryParse(url)?.hasAbsolutePath == true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: CustomAppBar(title: "Profil Saya", showLogo: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _showProfileOptions,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : (_photoUrl != null && _photoUrl!.isNotEmpty
                                        ? NetworkImage(_photoUrl!)
                                        : null),

                              child:
                                  (_profileImage == null &&
                                      !_isValidUrl(_photoUrl))
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 32,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(_name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(_email, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('Pengaturan'),
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PengaturanProfile(),
                            ),
                          );
                          if (updated == true) _loadUserData();
                        },
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text('Bantuan'),
                        onTap: () {},
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('Tentang Aplikasi'),
                        onTap: () {},
                      ),
                      const Divider(height: 0),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: _logout,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
