import 'package:equatable/equatable.dart';
import 'package:smart_receipt_mobile/shared/models/models.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  const DashboardLoaded({required this.tickets, required this.totalSpent});
  final List<Ticket> tickets;
  final double totalSpent;

  @override
  List<Object> get props => [tickets, totalSpent];
}

class DashboardError extends DashboardState {
  const DashboardError(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}
