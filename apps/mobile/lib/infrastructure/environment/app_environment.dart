abstract class AppEnvironment {
  const AppEnvironment({
    required this.name,
    required this.apiUrl,
    required this.authToken,
  });

  /// Environment name (e.g., 'dev', 'prod')
  final String name;

  /// Base API URL
  final String apiUrl;

  /// Authentication token for API requests
  final String authToken;
}
