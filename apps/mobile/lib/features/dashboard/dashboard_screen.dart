import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_event.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_state.dart';
import 'package:smart_receipt_mobile/features/dashboard/widgets/dashboard_summary_cards.dart';
import 'package:smart_receipt_mobile/features/dashboard/widgets/dashboard_scan_button.dart';
import 'package:smart_receipt_mobile/features/dashboard/widgets/dashboard_ticket_list.dart';
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
    return BlocProvider(
      create: (context) => DashboardBloc()..add(const DashboardLoadTickets()),
      child: Scaffold(
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
                    const SizedBox(height: 24),
                    Text(
                      'Tickets Recientes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DashboardTicketList(tickets: state.tickets),
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
      ),
    );
  }
}
