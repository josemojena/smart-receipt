import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_receipt_mobile/features/ticket_detail/bloc/ticket_detail_bloc.dart';
import 'package:smart_receipt_mobile/features/ticket_detail/bloc/ticket_detail_event.dart';
import 'package:smart_receipt_mobile/features/ticket_detail/bloc/ticket_detail_state.dart';
import 'package:smart_receipt_mobile/features/ticket_detail/widgets/ticket_product_item.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';
import 'package:smart_receipt_mobile/shared/widgets/bottom_nav_bar.dart';

class TicketDetailScreen extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketDetailBloc(ticket: ticket),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Detalle del Ticket',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocListener<TicketDetailBloc, TicketDetailState>(
          listener: (context, state) {
            if (state is TicketDetailDeleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ticket eliminado.')),
              );
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<TicketDetailBloc, TicketDetailState>(
            builder: (context, state) {
              if (state is TicketDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is TicketDetailInitial) {
                final currentTicket = state.ticket;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Información del Ticket
                      Text(
                        'Ticket #${currentTicket.id}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${currentTicket.storeName} - ${currentTicket.date.day}/${currentTicket.date.month}/${currentTicket.date.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Total Pagado
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pagado:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '€ ${currentTicket.totalSpent.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.red.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Listado de Productos
                      Text(
                        'Productos (${currentTicket.products.length} items)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Lista de Productos
                      Column(
                        children: currentTicket.products
                            .map(
                              (product) => TicketProductItem(product: product),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 32),

                      // Botón de Eliminación
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<TicketDetailBloc>().add(
                              const TicketDetailDelete(),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red.shade600,
                            side: BorderSide(
                              color: Colors.red.shade300,
                              width: 1.5,
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Eliminar Ticket',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        bottomNavigationBar: const BottomNavBar(
          currentIndex: 0,
          onTap: _handleNavTap,
        ),
      ),
    );
  }

  static void _handleNavTap(int index) {
    // TODO: Implementar navegación
  }
}
