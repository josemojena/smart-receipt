import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_receipt_mobile/shared/models/product.dart';
import 'package:smart_receipt_mobile/shared/models/ticket_data.dart';

part 'ticket.freezed.dart';
part 'ticket.g.dart';

/// Ticket model - compatible with TicketData from server
@freezed
sealed class Ticket with _$Ticket {
  const factory Ticket({
    required String id,
    required String storeName,
    required DateTime date,
    required List<Product> products,
    String? transactionId,
    String? time,
    double? finalTotal,
    @Default({}) Map<String, double> taxBreakdown,
  }) = _Ticket;

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  /// Create Ticket from TicketData
  factory Ticket.fromTicketData(TicketData data, {String? id}) {
    // Parse date from string (format: YYYY-MM-DD)
    DateTime? parsedDate;
    if (data.date != null) {
      try {
        parsedDate = DateTime.parse(data.date!);
      } catch (e) {
        parsedDate = DateTime.now();
      }
    } else {
      parsedDate = DateTime.now();
    }

    return Ticket(
      id:
          id ??
          data.transactionId ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      storeName: data.store ?? 'Unknown Store',
      date: parsedDate,
      products: data.items
          .map((item) => Product.fromReceiptItem(item))
          .toList(),
      transactionId: data.transactionId,
      time: data.time,
      finalTotal: data.finalTotal,
      taxBreakdown: data.taxBreakdown,
    );
  }
}

// Extension para propiedades computadas públicas
extension TicketExtension on Ticket {
  double get totalSpent =>
      finalTotal ??
      products.fold(
        0.0,
        (double sum, Product item) => sum + item.totalPrice,
      );

  int get totalItems => products.length;
}
