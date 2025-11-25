import 'package:flutter/material.dart';

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
        currentIndex: currentIndex,
        onTap: onTap,
        elevation: bottomNavTheme.elevation ?? 0,
        selectedLabelStyle: bottomNavTheme.selectedLabelStyle,
        unselectedLabelStyle: bottomNavTheme.unselectedLabelStyle,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 24),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 24),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border, size: 24),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none, size: 24),
            label: 'Alertas',
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
