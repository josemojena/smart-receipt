import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_receipt_mobile/features/ticket_detail/widgets/ticket_product_item.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';
import 'package:smart_receipt_mobile/shared/widgets/bottom_nav_bar.dart';

class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({super.key, required this.ticket});
  final Ticket ticket;

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  late Product _selectedProduct;

  @override
  void initState() {
    super.initState();
    // Seleccionar el producto más caro por defecto
    if (widget.ticket.products.isNotEmpty) {
      _selectedProduct = widget.ticket.products.reduce(
        (a, b) => a.totalPrice > b.totalPrice ? a : b,
      );
    } else {
      _selectedProduct = widget.ticket.products.first;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatTransactionId(String id) {
    // Try to parse as int for formatting, otherwise use as-is
    final intId = int.tryParse(id);
    if (intId != null) {
      return 'T${intId.toString().padLeft(3, '0')}';
    }
    return id; // Return as-is if not a number
  }

  void _onProductSelectionChanged(Product product, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedProduct = product;
      } else if (_selectedProduct == product) {
        // Si se deselecciona el producto actualmente seleccionado,
        // mantener la selección (no permitir deseleccionar)
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    'Volver al Historial',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text(
                    widget.ticket.storeName.toUpperCase(),
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            floating: true,
            snap: true,
            pinned: false,
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Total grande en verde
                            Text(
                              '€${widget.ticket.totalSpent.toStringAsFixed(2)}',
                              style: textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Información de la transacción
                            Text(
                              'Fecha: ${_formatDate(widget.ticket.date)} (${_formatTime(widget.ticket.date)})',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Transacción ID: ${_formatTransactionId(widget.ticket.id)}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Items: ${widget.ticket.products.length}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botón de Analizar (producto seleccionado) - Movido arriba para mejor visibilidad
                    if (widget.ticket.products.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.push(
                              '/product-analysis/${_selectedProduct.name}',
                              extra: _selectedProduct,
                            );
                          },
                          icon: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.analytics, size: 16),
                          ),
                          label: Text(
                            'Analizar "${_selectedProduct.name.toUpperCase()}"',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 32),

                    // Header de productos
                    Text(
                      'Detalle de Productos (${widget.ticket.products.length})',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lista de Productos
                    Column(
                      children: widget.ticket.products
                          .map(
                            (product) => TicketProductItem(
                              product: product,
                              isSelected: product == _selectedProduct,
                              onSelectionChanged: _onProductSelectionChanged,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Historial está activo
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
