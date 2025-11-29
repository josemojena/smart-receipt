import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_receipt_mobile/features/scan/bloc/scan_event.dart';
import 'package:smart_receipt_mobile/features/scan/bloc/scan_state.dart';
import 'package:smart_receipt_mobile/infrastructure/services/image_upload_service.dart';
import 'package:smart_receipt_mobile/shared/models/failure.dart';

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
    emit(ScanProcessing(imagePath: event.imagePath, progress: 0));

    bool isProcessingStateEmitted = false;

    final result = await _uploadService.processTicket(
      filePath: event.imagePath,
      onProgress: (progress) {
        // El progreso solo se actualiza durante la subida del archivo
        // Mostramos progreso hasta 90% (subida), luego cambiamos a procesamiento
        if (progress >= 0.9 && !isProcessingStateEmitted) {
          // Cuando la subida está casi completa, indicar que se está procesando
          isProcessingStateEmitted = true;
          emit(
            ScanProcessing(
              imagePath: event.imagePath,
              progress: 0.9,
              isProcessing: true,
            ),
          );
        } else if (progress < 0.9) {
          emit(ScanProcessing(imagePath: event.imagePath, progress: progress));
        }
      },
    );

    // Si la subida terminó pero no se emitió el estado de procesamiento,
    // significa que la subida fue muy rápida, ahora está procesando
    if (!isProcessingStateEmitted) {
      emit(
        ScanProcessing(
          imagePath: event.imagePath,
          progress: 0.9,
          isProcessing: true,
        ),
      );
    }

    result.fold(
      // Left: Failure
      (failure) {
        final errorMessage = _getFailureMessage(failure);
        emit(ScanError(errorMessage));
      },
      // Right: Success
      (response) {
        if (!response.success || response.data == null) {
          emit(
            const ScanError('Error: El servidor no pudo procesar el ticket'),
          );
          return;
        }

        emit(
          ScanProcessSuccess(
            imagePath: event.imagePath,
            response: response,
          ),
        );
      },
    );
  }

  String _getFailureMessage(Failure failure) {
    return failure.when(
      network: (message, statusCode) =>
          'Error de conexión: $message${statusCode != null ? ' (Código: $statusCode)' : ''}',
      server: (message, statusCode, errorData) =>
          'Error del servidor ($statusCode): $message',
      validation: (message, errors) {
        final errorsText = errors != null && errors.isNotEmpty
            ? '\n${errors.join('\n')}'
            : '';
        return 'Error de validación: $message$errorsText';
      },
      unknown: (message, error) => 'Error desconocido: $message',
    );
  }
}
