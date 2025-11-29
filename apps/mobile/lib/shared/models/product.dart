import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_receipt_mobile/shared/models/receipt_item.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Product model - compatible with ReceiptItem from server
/// This is a simplified view of ReceiptItem for UI purposes
@freezed
sealed class Product with _$Product {
  const factory Product({
    required String name,
    required double unitPrice,
    required double quantity,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Create Product from ReceiptItem
  factory Product.fromReceiptItem(ReceiptItem item) {
    return Product(
      name: item.normalizedName ?? item.originalName ?? 'Unknown',
      unitPrice: item.realUnitPrice ?? item.paidPrice ?? 0.0,
      quantity: item.quantity ?? 0.0,
    );
  }
}

extension ProductExtension on Product {
  double get totalPrice => unitPrice * quantity;
}
