import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/dashboard_bloc.dart';
import 'bloc/dashboard_event.dart';
import 'bloc/dashboard_state.dart';
import 'widgets/dashboard_summary_cards.dart';
import 'widgets/dashboard_scan_button.dart';
import 'widgets/dashboard_ticket_list.dart';
import 'package:smart_receipt_mobile/shared/widgets/bottom_nav_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc()..add(const DashboardLoadTickets()),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Mi Cartera de Compras',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black87),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black87,
              ),
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
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DashboardSummaryCards(
                      totalTickets: state.tickets.length,
                      totalSpent: state.totalSpent,
                    ),
                    const SizedBox(height: 32.0),
                    DashboardScanButton(
                      onPressed: () {
                        context.read<DashboardBloc>().add(
                          const DashboardScanTicket(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Abriendo escáner de cámara...'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                    const Text(
                      'Tickets Recientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    DashboardTicketList(tickets: state.tickets),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
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
