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

class ScanUploading extends ScanState {
  const ScanUploading({
    required this.imagePath,
    this.progress = 0,
  });

  final String imagePath;
  final double progress;

  @override
  List<Object> get props => [imagePath, progress];
}

class ScanUploadSuccess extends ScanState {
  const ScanUploadSuccess({
    required this.imagePath,
    required this.response,
  });

  final String imagePath;
  final Map<String, dynamic> response;

  @override
  List<Object> get props => [imagePath, response];
}
