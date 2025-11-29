import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_item.freezed.dart';
part 'receipt_item.g.dart';

/// Receipt item from server response
/// Matches the structure returned by the API
@freezed
sealed class ReceiptItem with _$ReceiptItem {
  const factory ReceiptItem({
    @JsonKey(name: 'original_name') required String? originalName,
    @JsonKey(name: 'normalized_name') required String? normalizedName,
    required String? category,
    required double? quantity,
    @JsonKey(name: 'unit_of_measure') required String? unitOfMeasure,
    @JsonKey(name: 'base_quantity') required double? baseQuantity,
    @JsonKey(name: 'base_unit_name') required String? baseUnitName,
    @JsonKey(name: 'paid_price') required double? paidPrice,
    @JsonKey(name: 'real_unit_price') required double? realUnitPrice,
    @JsonKey(name: 'original_quantity_raw') String? originalQuantityRaw,
    @JsonKey(name: 'original_unit_of_measure_raw')
    String? originalUnitOfMeasureRaw,
    @JsonKey(name: 'original_price_raw') double? originalPriceRaw,
  }) = _ReceiptItem;

  factory ReceiptItem.fromJson(Map<String, dynamic> json) =>
      _$ReceiptItemFromJson(json);
}

extension ReceiptItemExtension on ReceiptItem {
  /// Total price for this item (paid_price * quantity)
  double get totalPrice => (paidPrice ?? 0.0) * (quantity ?? 0.0);
}
