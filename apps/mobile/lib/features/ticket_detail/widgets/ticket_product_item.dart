import 'package:flutter/material.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';

class TicketProductItem extends StatelessWidget {
  final Product product;

  const TicketProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Color iconColor;
    Color iconTextColor;
    IconData iconData;

    // Asignar íconos basados en el nombre usando colores del ColorScheme
    if (product.name.toLowerCase().contains('leche') ||
        product.name.toLowerCase().contains('huevo')) {
      // Usar tertiary para productos lácteos
      iconColor = colorScheme.tertiaryContainer;
      iconTextColor = colorScheme.onTertiaryContainer;
      iconData = Icons.shopping_basket;
    } else if (product.name.toLowerCase().contains('carne') ||
        product.name.toLowerCase().contains('res')) {
      // Usar error para productos cárnicos (rojo)
      iconColor = colorScheme.errorContainer;
      iconTextColor = colorScheme.onErrorContainer;
      iconData = Icons.fastfood;
    } else {
      // Usar secondary para otros productos
      iconColor = colorScheme.secondaryContainer;
      iconTextColor = colorScheme.onSecondaryContainer;
      iconData = Icons.receipt_long;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Icono/Placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  iconData,
                  size: 30,
                  color: iconTextColor,
                ),
              ),
              const SizedBox(width: 12),
              // Detalles del Producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cant: ${product.quantity} uds. | P. Unit: € ${product.unitPrice.toStringAsFixed(2)}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Precio Total
              Text(
                '€ ${product.totalPrice.toStringAsFixed(2)}',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
