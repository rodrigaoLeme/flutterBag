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
  final int statusCode;
  const ApiException({
    required this.code,
    required this.title,
    required this.statusCode,
  });

  @override
  String toString() => 'ApiException($statusCode): $code $title';
}
