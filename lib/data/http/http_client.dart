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
  noConnectivity,
  timeout,
  unexpected;

  bool get isUnauthorized => this == HttpError.unauthorized;
  bool get isForbidden => this == HttpError.forbidden;
}
