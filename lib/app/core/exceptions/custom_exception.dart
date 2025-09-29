abstract class CustomException implements Exception {
  final String message;
  final StackTrace stackTrace;

  const CustomException({
    this.message = '',
    this.stackTrace = StackTrace.empty,
  });
}
