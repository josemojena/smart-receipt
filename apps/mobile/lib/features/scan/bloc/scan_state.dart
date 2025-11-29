import 'package:equatable/equatable.dart';
import 'package:smart_receipt_mobile/shared/models/ticket_processing_response.dart';

abstract class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object> get props => [];
}

class ScanInitial extends ScanState {
  const ScanInitial();
}

class ScanLoading extends ScanState {
  const ScanLoading();
}

class ScanImageSelected extends ScanState {
  const ScanImageSelected(this.imagePath);

  final String imagePath;

  @override
  List<Object> get props => [imagePath];
}

class ScanError extends ScanState {
  const ScanError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class ScanProcessing extends ScanState {
  const ScanProcessing({
    required this.imagePath,
    this.progress = 0,
    this.isProcessing = false,
  });

  final String imagePath;
  final double progress;
  final bool isProcessing;

  @override
  List<Object> get props => [imagePath, progress, isProcessing];
}

class ScanProcessSuccess extends ScanState {
  const ScanProcessSuccess({
    required this.imagePath,
    required this.response,
  });

  final String imagePath;
  final TicketProcessingResponse response;

  @override
  List<Object> get props => [imagePath, response];
}
