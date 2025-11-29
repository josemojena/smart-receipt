import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_receipt_mobile/shared/models/receipt_item.dart';

part 'ticket_data.freezed.dart';
part 'ticket_data.g.dart';

/// Ticket data from server response
/// Matches the structure returned by the API
@freezed
sealed class TicketData with _$TicketData {
  const factory TicketData({
    required String? store,
    @JsonKey(name: 'transaction_id') required String? transactionId,
    required String? date,
    required String? time,
    @JsonKey(name: 'final_total') required double? finalTotal,
    @JsonKey(name: 'tax_breakdown')
    @Default({})
    Map<String, double> taxBreakdown,
    required List<ReceiptItem> items,
  }) = _TicketData;

  factory TicketData.fromJson(Map<String, dynamic> json) =>
      _$TicketDataFromJson(json);
}

extension TicketDataExtension on TicketData {
  /// Total number of items
  int get totalItems => items.length;

  /// Total spent (from final_total or calculated from items)
  double get totalSpent =>
      finalTotal ??
      items.fold(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );
}
