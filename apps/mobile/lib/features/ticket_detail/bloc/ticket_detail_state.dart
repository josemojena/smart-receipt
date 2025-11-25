import 'package:equatable/equatable.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';

abstract class TicketDetailState extends Equatable {
  const TicketDetailState();

  @override
  List<Object> get props => [];
}

class TicketDetailInitial extends TicketDetailState {
  final Ticket ticket;

  const TicketDetailInitial({required this.ticket});

  @override
  List<Object> get props => [ticket];
}

class TicketDetailLoading extends TicketDetailState {
  const TicketDetailLoading();
}

class TicketDetailDeleted extends TicketDetailState {
  const TicketDetailDeleted();
}
