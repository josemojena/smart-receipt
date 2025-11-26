import 'package:dio/dio.dart';

/// Collection of Dio interceptors
class DioInterceptors {
  /// Get all interceptors for Dio
  static List<Interceptor> getInterceptors() {
    return [
      LoggingInterceptor(),
      ErrorInterceptor(),
    ];
  }
}

/// Logging interceptor for debugging HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('🚀 [REQUEST] ${options.method} ${options.uri}');
    if (options.data != null) {
      print('📤 [DATA] ${options.data}');
    }
    if (options.queryParameters.isNotEmpty) {
      print('🔍 [QUERY] ${options.queryParameters}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    print('✅ [RESPONSE] ${response.statusCode} ${response.requestOptions.uri}');
    if (response.data != null) {
      print('📥 [DATA] ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ [ERROR] ${err.type} - ${err.message}');
    if (err.response != null) {
      print(
        '📥 [ERROR RESPONSE] ${err.response?.statusCode} - ${err.response?.data}',
      );
    }
    super.onError(err, handler);
  }
}

/// Authentication interceptor for adding auth tokens
class AuthInterceptor extends Interceptor {
  String? _token;

  /// Set authentication token
  void setToken(String? token) {
    _token = token;
  }

  /// Clear authentication token
  void clearToken() {
    _token = null;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    if (_token != null && _token!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token expired or invalid
    if (err.response?.statusCode == 401) {
      // Clear token and potentially trigger logout
      _token = null;
      // TODO: Implement logout logic or token refresh
    }
    super.onError(err, handler);
  }
}

/// Error handling interceptor
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Transform DioException to a more user-friendly error
    final error = _handleError(err);

    // You can modify the error or create a custom error response
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: error,
        message: error,
      ),
    );
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badCertificate:
        return 'Certificate error. Please try again later.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'An error occurred. Status code: $statusCode';
    }
  }
}
