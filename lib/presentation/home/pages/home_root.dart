// home_root.dart
import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_bottom_nav_bar.dart';
import 'package:gloymoneymanagement/presentation/home/pages/home_screen.dart';
import 'package:gloymoneymanagement/presentation/menabung/pages/saving_screen.dart';
import 'package:gloymoneymanagement/presentation/pensiun/pages/pensiun_screen.dart';
import 'package:gloymoneymanagement/presentation/akun/pages/profile_screen.dart';

class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});

  static void navigateToTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_HomeRootState>();
    state?._onTap(index);
  }

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> with TickerProviderStateMixin {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    SavingScreen(),
    PensiunScreen(),
    ProfileScreen(),
  ];

  late final List<AnimationController> _fadeControllers;
  late final List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();

    _fadeControllers = List.generate(
      _screens.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    _fadeAnimations = _fadeControllers
        .map((controller) => Tween<double>(begin: 0.0, end: 1.0).animate(controller))
        .toList();

    _fadeControllers[_currentIndex].forward();
  }

  void _onTap(int index) {
    if (index != _currentIndex) {
      _fadeControllers[_currentIndex].reverse();
      _fadeControllers[index].forward();
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _fadeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(_screens.length, (index) {
          return IgnorePointer(
            ignoring: _currentIndex != index,
            child: FadeTransition(
              opacity: _fadeAnimations[index],
              child: Offstage(
                offstage: _currentIndex != index,
                child: _screens[index],
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
