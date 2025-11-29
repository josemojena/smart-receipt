import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_event.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_state.dart';
import 'package:smart_receipt_mobile/features/dashboard/widgets/dashboard_summary_cards.dart';
import 'package:smart_receipt_mobile/features/dashboard/widgets/dashboard_scan_button.dart';
import 'package:smart_receipt_mobile/features/dashboard/widgets/dashboard_ticket_list.dart';
import 'package:smart_receipt_mobile/features/dashboard/widgets/dashboard_empty_state.dart';
import 'package:smart_receipt_mobile/shared/widgets/bottom_nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.currentIndex = 0,
    required this.onNavTap,
  });
  final int currentIndex;
  final void Function(int) onNavTap;

  @override
  Widget build(BuildContext context) {
    // El DashboardBloc ya está disponible globalmente, solo cargamos tickets si no están cargados
    final dashboardBloc = context.read<DashboardBloc>();
    if (dashboardBloc.state is DashboardInitial) {
      dashboardBloc.add(const DashboardLoadTickets());
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Smart Receipt Scanner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DashboardBloc>().add(
                        const DashboardLoadTickets(),
                      );
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is DashboardLoaded) {
            if (state.tickets.isEmpty) {
              return const DashboardEmptyState();
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DashboardSummaryCards(
                    totalTickets: state.tickets.length,
                    totalSpent: state.totalSpent,
                  ),
                  const SizedBox(height: 32),
                  DashboardScanButton(
                    onPressed: () {
                      context.push('/scan');
                    },
                  ),
                  const SizedBox(height: 24),
                  // Header con título e icono
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Últimas facturas ...',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.receipt_long,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Mostrar solo los primeros 2 tickets
                  DashboardTicketList(
                    tickets: state.tickets.take(2).toList(),
                  ),
                  const SizedBox(height: 12),
                  // Link para ver todas las transacciones
                  InkWell(
                    onTap: () {
                      context.go('/history');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ver todas las transacciones',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: currentIndex,
        onTap: onNavTap,
      ),
    );
  }
}
