import 'package:smart_receipt_mobile/shared/models/product.dart';

class Ticket {
  final int id;
  final String storeName;
  final DateTime date;
  final List<Product> products;

  Ticket({
    required this.id,
    required this.storeName,
    required this.date,
    required this.products,
  });

  double get totalSpent =>
      products.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get totalItems => products.length;
}
