import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      actions: actions,
      iconTheme: const IconThemeData(color: Colors.black),
      title: showLogo
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'lib/core/assets/images/logo_polos.png',
                  height: 30,
                ),
                if (title.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Text(
                    title,
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
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                letterSpacing: 1,
              ),
            ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
