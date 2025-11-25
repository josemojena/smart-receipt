class Product {
  final String name;
  final double unitPrice;
  final int quantity;

  const Product({
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });

  double get totalPrice => unitPrice * quantity;
}
