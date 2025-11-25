import 'package:flutter/material.dart';
import 'package:smart_receipt_mobile/features/dashboard/dashboard_screen.dart';
import 'package:smart_receipt_mobile/features/profile/profile_screen.dart';
import 'package:smart_receipt_mobile/shared/widgets/bottom_nav_bar.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: [
        DashboardScreen(
          currentIndex: _currentIndex,
          onNavTap: _onNavTap,
        ),
        Scaffold(
          body: const Center(
            child: Text('Buscar'),
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
          ),
        ),
        Scaffold(
          body: const Center(
            child: Text('Favoritos'),
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
          ),
        ),
        Scaffold(
          body: const Center(
            child: Text('Alertas'),
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
          ),
        ),
        ProfileScreen(
          currentIndex: _currentIndex,
          onNavTap: _onNavTap,
        ),
      ],
    );
  }
}
