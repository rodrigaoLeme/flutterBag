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
