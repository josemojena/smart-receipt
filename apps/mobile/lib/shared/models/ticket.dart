import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_receipt_mobile/shared/models/product.dart';

part 'ticket.freezed.dart';
part 'ticket.g.dart';

@freezed
sealed class Ticket with _$Ticket {
  const factory Ticket({
    required int id,
    required String storeName,
    required DateTime date,
    required List<Product> products,
  }) = _Ticket;

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
}

// Extension para propiedades computadas públicas
extension TicketExtension on Ticket {
  double get totalSpent => products.fold(
    0.0,
    (double sum, Product item) => sum + item.unitPrice * item.quantity,
  );

  int get totalItems => products.length;
}
