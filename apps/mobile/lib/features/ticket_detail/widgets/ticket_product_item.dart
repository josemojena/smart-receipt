import 'package:flutter/material.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';

class TicketProductItem extends StatelessWidget {
  final Product product;

  const TicketProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    Color iconColor;
    IconData iconData;

    // Asignar íconos basados en el nombre (simulación)
    if (product.name.toLowerCase().contains('leche') ||
        product.name.toLowerCase().contains('huevo')) {
      iconColor = Colors.yellow.shade100;
      iconData = Icons.shopping_basket;
    } else if (product.name.toLowerCase().contains('carne') ||
        product.name.toLowerCase().contains('res')) {
      iconColor = Colors.red.shade100;
      iconData = Icons.fastfood;
    } else {
      iconColor = Colors.blue.shade100;
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
                child: Icon(iconData, size: 30, color: Colors.grey.shade700),
              ),
              const SizedBox(width: 12),
              // Detalles del Producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cant: ${product.quantity} uds. | P. Unit: € ${product.unitPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Precio Total
              Text(
                '€ ${product.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
