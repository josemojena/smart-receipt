class Product {
  const Product({
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });
  final String name;
  final double unitPrice;
  final int quantity;

  double get totalPrice => unitPrice * quantity;
}
