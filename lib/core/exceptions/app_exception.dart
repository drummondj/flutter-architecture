class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final Object? cause;

  AppException({required this.message, this.stackTrace, this.cause});
}
