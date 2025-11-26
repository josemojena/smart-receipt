import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomNavTheme = theme.bottomNavigationBarTheme;
    final location = GoRouterState.of(context).uri.path;

    // Determinar el índice actual basado en la ruta
    int activeIndex = currentIndex;
    if (location == '/' || location.startsWith('/ticket/')) {
      activeIndex = 0;
    } else if (location == '/history') {
      activeIndex = 1;
    } else if (location == '/advisor') {
      activeIndex = 2;
    } else if (location == '/profile') {
      activeIndex = 3;
    }

    return Container(
      decoration: BoxDecoration(
        color: bottomNavTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: bottomNavTheme.selectedItemColor,
        unselectedItemColor: bottomNavTheme.unselectedItemColor,
        backgroundColor: bottomNavTheme.backgroundColor,
        currentIndex: activeIndex,
        onTap: (index) {
          onTap(index);
          // Navegar con go_router
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/history');
              break;
            case 2:
              context.go('/advisor');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        elevation: bottomNavTheme.elevation ?? 0,
        selectedLabelStyle: bottomNavTheme.selectedLabelStyle,
        unselectedLabelStyle: bottomNavTheme.unselectedLabelStyle,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 24),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list, size: 24),
            label: 'Historial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline, size: 24),
            label: 'Asesor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 24),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
