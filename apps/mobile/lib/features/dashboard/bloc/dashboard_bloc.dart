import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_event.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_state.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  // Mock data - En el futuro esto vendrá de un repositorio
  List<Ticket> _tickets = [
    Ticket(
      id: 1,
      storeName: 'Supermercado Local',
      date: DateTime(2024, 9, 20),
      products: const [
        Product(name: 'Leche Entera (1L)', unitPrice: 1.25, quantity: 2),
        Product(
          name: 'Carne Picada de Res (500g)',
          unitPrice: 7.99,
          quantity: 1,
        ),
        Product(
          name: 'Papel Higiénico (8 rollos)',
          unitPrice: 4.50,
          quantity: 1,
        ),
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

  DashboardBloc() : super(const DashboardInitial()) {
    on<DashboardLoadTickets>(_onLoadTickets);
    on<DashboardScanTicket>(_onScanTicket);
    on<DashboardDeleteTicket>(_onDeleteTicket);
  }

  Future<void> _onLoadTickets(
    DashboardLoadTickets event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    // Simular carga asíncrona
    await Future<void>.delayed(const Duration(milliseconds: 500));

    _updateState(emit);
  }

  Future<void> _onScanTicket(
    DashboardScanTicket event,
    Emitter<DashboardState> emit,
  ) async {
    // Aquí se implementará la lógica de escaneo
    // Por ahora solo emitimos el estado actual
  }

  Future<void> _onDeleteTicket(
    DashboardDeleteTicket event,
    Emitter<DashboardState> emit,
  ) async {
    _tickets.removeWhere((ticket) => ticket.id == event.ticketId);
    _updateState(emit);
  }

  void _updateState(Emitter<DashboardState> emit) {
    if (_tickets.isEmpty) {
      emit(const DashboardLoaded(tickets: [], totalSpent: 0.0));
      return;
    }

    final totalSpent = _tickets.fold(
      0.0,
      (double sum, Ticket ticket) => sum + ticket.totalSpent,
    );

    emit(
      DashboardLoaded(tickets: List.from(_tickets), totalSpent: totalSpent),
    );
  }

  // Método para obtener un ticket por ID (para el router)
  Ticket? getTicketById(int id) {
    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      return null;
    }
  }
}
