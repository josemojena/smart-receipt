import 'package:smart_receipt_mobile/shared/models/models.dart';

// Mock data - En el futuro esto vendrá de un repositorio
final List<Ticket> mockTickets = [
  Ticket(
    id: 1,
    storeName: 'Supermercado Local',
    date: DateTime(2024, 9, 20),
    products: const [
      Product(name: 'Leche Entera (1L)', unitPrice: 1.25, quantity: 2),
      Product(name: 'Carne Picada de Res (500g)', unitPrice: 7.99, quantity: 1),
      Product(name: 'Papel Higiénico (8 rollos)', unitPrice: 4.50, quantity: 1),
      Product(name: 'Manzanas Golden (kg)', unitPrice: 2.10, quantity: 1),
    ],
  ),
  Ticket(
    id: 2,
    storeName: 'Farmacia Cruz Azul',
    date: DateTime(2024, 9, 19),
    products: const [
      Product(name: 'Paracetamol 500mg', unitPrice: 3.50, quantity: 1),
      Product(name: 'Vitamina C (30 tabs)', unitPrice: 9, quantity: 1),
    ],
  ),
];

