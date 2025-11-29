import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Failure model for error handling
@freezed
sealed class Failure with _$Failure {
  /// Network failure (connection issues, timeouts, etc.)
  const factory Failure.network({
    required String message,
    int? statusCode,
  }) = NetworkFailure;

  /// Server failure (4xx, 5xx errors)
  const factory Failure.server({
    required String message,
    required int statusCode,
    Map<String, dynamic>? errorData,
  }) = ServerFailure;

  /// Validation failure (invalid data, missing fields, etc.)
  const factory Failure.validation({
    required String message,
    List<String>? errors,
  }) = ValidationFailure;

  /// Unknown failure
  const factory Failure.unknown({
    required String message,
    Object? error,
  }) = UnknownFailure;
}
