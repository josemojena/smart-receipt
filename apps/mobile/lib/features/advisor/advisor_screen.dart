import 'package:flutter/material.dart';
import 'package:smart_receipt_mobile/shared/widgets/bottom_nav_bar.dart';

class AdvisorScreen extends StatelessWidget {
  const AdvisorScreen({
    super.key,
    this.currentIndex = 2,
    required this.onNavTap,
  });
  final int currentIndex;
  final void Function(int) onNavTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Asesor',
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      body: Center(
        child: Text(
          'Asesor Inteligente',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onNavTap,
      ),
    );
  }
}
