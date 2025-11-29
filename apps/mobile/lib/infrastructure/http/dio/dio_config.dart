/// Configuration for Dio HTTP client
class DioConfig {
  static const Duration connectTimeout = Duration(seconds: 30);
  // Increased timeout for image processing with AI (Gemini can take longer)
  static const Duration receiveTimeout = Duration(seconds: 120);
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
