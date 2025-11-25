import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_receipt_mobile/features/ticket_detail/bloc/ticket_detail_event.dart';
import 'package:smart_receipt_mobile/features/ticket_detail/bloc/ticket_detail_state.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';

class TicketDetailBloc extends Bloc<TicketDetailEvent, TicketDetailState> {
  TicketDetailBloc({required Ticket ticket})
    : super(TicketDetailInitial(ticket: ticket)) {
    on<TicketDetailLoad>(_onLoad);
    on<TicketDetailDelete>(_onDelete);
  }

  Future<void> _onLoad(
    TicketDetailLoad event,
    Emitter<TicketDetailState> emit,
  ) async {
    // El ticket ya está disponible, no necesitamos loading
    // Aquí se cargarían datos adicionales si fuera necesario en el futuro
    // Por ahora, el estado inicial ya tiene el ticket
  }

  Future<void> _onDelete(
    TicketDetailDelete event,
    Emitter<TicketDetailState> emit,
  ) async {
    emit(const TicketDetailDeleted());
  }
}
