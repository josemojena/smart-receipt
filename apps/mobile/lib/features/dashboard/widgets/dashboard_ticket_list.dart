import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';

class DashboardTicketList extends StatelessWidget {
  const DashboardTicketList({super.key, required this.tickets});
  final List<Ticket> tickets;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: tickets.map((ticket) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () async {
              await context.push('/ticket/${ticket.id}');
            },
            borderRadius: BorderRadius.circular(12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticket.storeName,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _formatTicketInfo(ticket),
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '€ ${ticket.totalSpent.toStringAsFixed(2)}',
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatTicketInfo(Ticket ticket) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final ticketDay = DateTime(
      ticket.date.year,
      ticket.date.month,
      ticket.date.day,
    );
    final difference = today.difference(ticketDay).inDays;

    String dateText;
    if (difference == 0) {
      dateText = 'Hoy';
    } else if (difference == 1) {
      dateText = 'Ayer';
    } else if (difference < 7) {
      dateText = 'Hace $difference días';
    } else {
      // Formato manual: "24 Nov 2024"
      const months = [
        'Ene',
        'Feb',
        'Mar',
        'Abr',
        'May',
        'Jun',
        'Jul',
        'Ago',
        'Sep',
        'Oct',
        'Nov',
        'Dic',
      ];
      dateText =
          '${ticket.date.day} ${months[ticket.date.month - 1]} ${ticket.date.year}';
    }

    if (ticket.time != null && ticket.time!.isNotEmpty) {
      return '$dateText • ${ticket.time} • ${ticket.totalItems} items';
    }

    return '$dateText • ${ticket.totalItems} items';
  }
}
