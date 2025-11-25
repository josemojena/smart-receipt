import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardLoadTickets extends DashboardEvent {
  const DashboardLoadTickets();
}

class DashboardScanTicket extends DashboardEvent {
  const DashboardScanTicket();
}
