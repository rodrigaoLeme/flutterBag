enum HttpMethod { get, post, put, patch, delete }

abstract class HttpClient {
  Future<dynamic> request({
    required String url,
    required HttpMethod method,
    Map? body,
    Map? headers,
    Map<String, dynamic>? queryParameters,
  });
}

enum HttpError {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  serverError,
  invalidData,
  noConnectivity,
  tooManyRequests,
  timeout,
  unexpected;

  bool get isUnauthorized => this == HttpError.unauthorized;
  bool get isForbidden => this == HttpError.forbidden;
}

class ApiException implements Exception {
  final String code;
  final String title;
  final String detail;
  final int statusCode;
  final Map<String, List<String>> errors;
  const ApiException({
    required this.code,
    required this.title,
    this.detail = '',
    required this.statusCode,
    this.errors = const {},
  });

  String get fullMessage {
    if (errors.isEmpty) {
      return title.isNotEmpty ? title : detail;
    }
    final buffer = StringBuffer();
    if (title.isNotEmpty) buffer.writeln(title);
    for (final entry in errors.entries) {
      for (final message in entry.value) {
        buffer.writeln('• $message');
      }
    }
    return buffer.toString().trim();
  }

  @override
  String toString() => 'ApiException($statusCode): $code $title';
}
