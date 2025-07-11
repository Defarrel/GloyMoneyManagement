import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/presentation/user/notifikasi/notifikasi.dart';
import 'package:gloymoneymanagement/services/service_notif_checker.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showLogo = true,
    this.actions,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool hasNotif = false;

  @override
  void initState() {
    super.initState();
    _checkNotif();
  }

  Future<void> _checkNotif() async {
    final result = await NotifCheckerService.hasPendingInvitation();
    if (mounted) {
      setState(() {
        hasNotif = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.black),
      title: widget.showLogo
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'lib/core/assets/images/logo_polos.png',
                  height: 30,
                ),
                if (widget.title.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ],
            )
          : Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                letterSpacing: 1,
              ),
            ),
      actions: [
        ...?widget.actions,
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_none),
              if (hasNotif)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Notifikasi()),
            );
            _checkNotif(); // refresh setelah kembali
          },
        ),
      ],
    );
  }
}
