import 'package:equatable/equatable.dart';

abstract class TicketDetailEvent extends Equatable {
  const TicketDetailEvent();

  @override
  List<Object> get props => [];
}

class TicketDetailLoad extends TicketDetailEvent {
  const TicketDetailLoad();
}

class TicketDetailDelete extends TicketDetailEvent {
  const TicketDetailDelete();
}
