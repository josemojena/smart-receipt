import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

/// Service for uploading images to the backend
class ImageUploadService {
  final Dio _dio;

  ImageUploadService(this._dio);

  /// Get Dio instance from service locator
  factory ImageUploadService.fromGetIt() {
    return ImageUploadService(GetIt.instance<Dio>());
  }

  /// Upload a single image from ImageSource
  ///
  /// [source] - The source of the image (camera or gallery)
  /// [onProgress] - Optional callback to track upload progress (0.0 to 1.0)
  ///
  /// Returns the response data as Map, or null if upload failed or was cancelled
  Future<Map<String, dynamic>?> uploadImage({
    required ImageSource source,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await uploadFile(
        filePath: image.path,
        fileName: image.name,
        onProgress: onProgress,
      );
    } catch (e) {
      throw Exception('Error selecting image: $e');
    }
  }

  /// Upload an image file from a file path
  ///
  /// [filePath] - Path to the image file
  /// [fileName] - Name of the file (optional, defaults to extracted from path)
  /// [onProgress] - Optional callback to track upload progress (0.0 to 1.0)
  ///
  /// Returns the response data as Map
  Future<Map<String, dynamic>> uploadFile({
    required String filePath,
    String? fileName,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName ?? filePath.split('/').last,
        ),
      });

      final response = await _dio.post<Map<String, dynamic>>(
        '/upload',
        data: formData,
        onSendProgress: (sent, total) {
          if (onProgress != null && total > 0) {
            final progress = sent / total;
            onProgress(progress);
          }
        },
      );

      return response.data ?? <String, dynamic>{};
    } on DioException catch (e) {
      throw Exception('Error uploading image: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Upload multiple images
  ///
  /// [filePaths] - List of file paths to upload
  /// [onProgress] - Optional callback to track upload progress (0.0 to 1.0)
  ///
  /// Returns the response data as Map
  Future<Map<String, dynamic>> uploadMultipleFiles({
    required List<String> filePaths,
    void Function(double progress)? onProgress,
  }) async {
    try {
      final formData = FormData();

      for (var filePath in filePaths) {
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(
              filePath,
              filename: filePath.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '/upload-multiple',
        data: formData,
        onSendProgress: (sent, total) {
          if (onProgress != null && total > 0) {
            onProgress(sent / total);
          }
        },
      );

      return response.data ?? <String, dynamic>{};
    } on DioException catch (e) {
      throw Exception('Error uploading images: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
