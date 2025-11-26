import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_receipt_mobile/features/product_analysis/widgets/product_analysis_summary_cards.dart';
import 'package:smart_receipt_mobile/features/product_analysis/widgets/product_price_comparison.dart';
import 'package:smart_receipt_mobile/features/product_analysis/widgets/product_price_evolution.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';
import 'package:smart_receipt_mobile/shared/widgets/bottom_nav_bar.dart';

class ProductAnalysisScreen extends StatelessWidget {
  const ProductAnalysisScreen({
    super.key,
    required this.product,
  });
  final Product product;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Text(
              '< Volver al Detalle',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.show_chart,
              color: colorScheme.onSurface,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            Text(
              'Análisis de "${product.name.toUpperCase()}"',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),

            // Cards de resumen
            ProductAnalysisSummaryCards(product: product),
            const SizedBox(height: 32),

            // Gráfico de evolución de precio
            ProductPriceEvolution(product: product),
            const SizedBox(height: 32),

            // Comparativa de precios por tienda
            ProductPriceComparison(product: product),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Asesor está activo
        onTap: (index) {
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
      ),
    );
  }
}
