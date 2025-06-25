import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLogo;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: showLogo
          ? Image.asset(
              'lib/core/assets/images/logo_polos.png',
              height: 30,
            )
          : Text(
              title,
              style: const TextStyle(color: Colors.black),
            ),
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
