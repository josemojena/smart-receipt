import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_receipt_mobile/features/scan/bloc/scan_event.dart';
import 'package:smart_receipt_mobile/features/scan/bloc/scan_state.dart';
import 'package:smart_receipt_mobile/infrastructure/services/image_upload_service.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc({
    ImageUploadService? uploadService,
  }) : _uploadService = uploadService ?? GetIt.instance<ImageUploadService>(),
       super(const ScanInitial()) {
    on<ScanOpenCamera>(_onOpenCamera);
    on<ScanOpenGallery>(_onOpenGallery);
    on<ScanClearImage>(_onClearImage);
    on<ScanUploadImage>(_onUploadImage);
  }

  final ImagePicker _imagePicker = ImagePicker();
  final ImageUploadService _uploadService;

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
    } on Exception catch (e) {
      emit(ScanError('Error al abrir la cámara: $e'));
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
    } on Exception catch (e) {
      emit(ScanError('Error al abrir la galería: $e'));
    }
  }

  Future<void> _onClearImage(
    ScanClearImage event,
    Emitter<ScanState> emit,
  ) async {
    emit(const ScanInitial());
  }

  Future<void> _onUploadImage(
    ScanUploadImage event,
    Emitter<ScanState> emit,
  ) async {
    emit(ScanUploading(imagePath: event.imagePath, progress: 0));

    try {
      final response = await _uploadService.uploadFile(
        filePath: event.imagePath,
        onProgress: (progress) {
          emit(ScanUploading(imagePath: event.imagePath, progress: progress));
        },
      );

      emit(
        ScanUploadSuccess(
          imagePath: event.imagePath,
          response: response,
        ),
      );
    } on Exception catch (e) {
      emit(ScanError('Error al subir la imagen: $e'));
    }
  }
}
