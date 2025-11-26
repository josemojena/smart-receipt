import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_receipt_mobile/features/scan/bloc/scan_event.dart';
import 'package:smart_receipt_mobile/features/scan/bloc/scan_state.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ImagePicker _imagePicker = ImagePicker();

  ScanBloc() : super(const ScanInitial()) {
    on<ScanOpenCamera>(_onOpenCamera);
    on<ScanOpenGallery>(_onOpenGallery);
    on<ScanClearImage>(_onClearImage);
  }

  Future<void> _onOpenCamera(
    ScanOpenCamera event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanLoading());

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image != null) {
        emit(ScanImageSelected(image.path));
      } else {
        emit(const ScanInitial());
      }
    } catch (e) {
      emit(ScanError('Error al abrir la cámara: ${e.toString()}'));
    }
  }

  Future<void> _onOpenGallery(
    ScanOpenGallery event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanLoading());

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        emit(ScanImageSelected(image.path));
      } else {
        emit(const ScanInitial());
      }
    } catch (e) {
      emit(ScanError('Error al abrir la galería: ${e.toString()}'));
    }
  }

  Future<void> _onClearImage(
    ScanClearImage event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanInitial());
  }
}
