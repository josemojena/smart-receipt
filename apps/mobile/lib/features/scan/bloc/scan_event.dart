import 'package:equatable/equatable.dart';

abstract class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object> get props => [];
}

class ScanOpenCamera extends ScanEvent {
  const ScanOpenCamera();
}

class ScanOpenGallery extends ScanEvent {
  const ScanOpenGallery();
}

class ScanClearImage extends ScanEvent {
  const ScanClearImage();
}

class ScanUploadImage extends ScanEvent {
  const ScanUploadImage(this.imagePath);

  final String imagePath;

  @override
  List<Object> get props => [imagePath];
}
