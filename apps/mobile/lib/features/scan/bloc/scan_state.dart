import 'package:equatable/equatable.dart';

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
  final String imagePath;

  const ScanImageSelected(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class ScanError extends ScanState {
  final String message;

  const ScanError(this.message);

  @override
  List<Object> get props => [message];
}

