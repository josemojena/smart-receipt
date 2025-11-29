import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_event.dart';
import 'package:smart_receipt_mobile/features/dashboard/bloc/dashboard_state.dart';
import 'package:smart_receipt_mobile/features/history/repositories/tickets_repository.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final TicketsRepository _ticketsRepository;
  List<Ticket> _tickets = [];

  DashboardBloc({
    TicketsRepository? ticketsRepository,
  }) : _ticketsRepository =
           ticketsRepository ?? GetIt.instance<TicketsRepository>(),
       super(const DashboardInitial()) {
    on<DashboardLoadTickets>(_onLoadTickets);
    on<DashboardScanTicket>(_onScanTicket);
    on<DashboardDeleteTicket>(_onDeleteTicket);
  }

  Future<void> _onLoadTickets(
    DashboardLoadTickets event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());

    final result = await _ticketsRepository.getTickets();

    result.fold(
      // Left: Failure
      (failure) {
        emit(
          DashboardError(_getFailureMessage(failure)),
        );
      },
      // Right: Success
      (tickets) {
        _tickets = tickets;
        _updateState(emit);
      },
    );
  }

  String _getFailureMessage(Failure failure) {
    return failure.when(
      network: (message, statusCode) =>
          'Error de conexión: $message${statusCode != null ? ' (Código: $statusCode)' : ''}',
      server: (message, statusCode, errorData) =>
          'Error del servidor ($statusCode): $message',
      validation: (message, errors) {
        final errorsText = errors != null && errors.isNotEmpty
            ? '\n${errors.join('\n')}'
            : '';
        return 'Error de validación: $message$errorsText';
      },
      unknown: (message, error) => 'Error desconocido: $message',
    );
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
  Ticket? getTicketById(String id) {
    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      return null;
    }
  }
}
