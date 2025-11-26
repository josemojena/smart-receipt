import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_receipt_mobile/features/advisor/advisor_screen.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:smart_receipt_mobile/features/dashboard/dashboard_screen.dart';
import 'package:smart_receipt_mobile/features/history/history_screen.dart';
import 'package:smart_receipt_mobile/features/product_analysis/product_analysis_screen.dart';
import 'package:smart_receipt_mobile/features/profile/profile_screen.dart';
import 'package:smart_receipt_mobile/features/scan/scan_screen.dart';
import 'package:smart_receipt_mobile/features/ticket_detail/ticket_detail_screen.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';

class AppRouter {
  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(
          currentIndex: 0,
          onNavTap: _handleNavTap,
        ),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(
          currentIndex: 1,
          onNavTap: _handleNavTap,
        ),
      ),
      GoRoute(
        path: '/advisor',
        builder: (context, state) => const AdvisorScreen(
          currentIndex: 2,
          onNavTap: _handleNavTap,
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(
          currentIndex: 3,
          onNavTap: _handleNavTap,
        ),
      ),
      GoRoute(
        path: '/scan',
        builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
        path: '/ticket/:id',
        builder: (context, state) {
          final ticketId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          // Obtener el ticket del DashboardBloc
          final dashboardBloc = context.read<DashboardBloc>();
          final ticket = dashboardBloc.getTicketById(ticketId);

          if (ticket == null) {
            // Si no se encuentra el ticket, volver al dashboard
            return const DashboardScreen(
              currentIndex: 0,
              onNavTap: _handleNavTap,
            );
          }

          return TicketDetailScreen(ticket: ticket);
        },
      ),
      GoRoute(
        path: '/product-analysis/:name',
        builder: (context, state) {
          final product = state.extra as Product?;
          if (product == null) {
            // Si no hay producto, volver atrás
            context.pop();
            return const SizedBox.shrink();
          }
          return ProductAnalysisScreen(product: product);
        },
      ),
    ],
  );

  static void _handleNavTap(int index) {
    switch (index) {
      case 0:
        _router.go('/');
        break;
      case 1:
        _router.go('/history');
        break;
      case 2:
        _router.go('/advisor');
        break;
      case 3:
        _router.go('/profile');
        break;
    }
  }
}
