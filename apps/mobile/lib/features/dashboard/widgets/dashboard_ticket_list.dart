import 'package:flutter/material.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';
import 'package:smart_receipt_mobile/features/ticket_detail/ticket_detail_screen.dart';

class DashboardTicketList extends StatelessWidget {
  final List<Ticket> tickets;

  const DashboardTicketList({super.key, required this.tickets});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tickets.map((ticket) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => TicketDetailScreen(ticket: ticket),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticket.storeName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${ticket.date.day} de ${ticket.date.month}, ${ticket.totalItems} items',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '€ ${ticket.totalSpent.toStringAsFixed(2)}',
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
          ),
        );
      }).toList(),
    );
  }
}
