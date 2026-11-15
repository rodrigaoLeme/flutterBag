enum HttpMethod { get, post, put, patch, delete }

abstract class HttpClient {
  Future<dynamic> request({
    required String url,
    required HttpMethod method,
    Map? body,
    Map? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<HttpUploadResponse> upload({
    required String url,
    required HttpMethod method,
    required MultipartPayload payload,
    Map? headers,
    void Function(int sent, int total)? onSendProgress,
  });
}

class MultipartFileData {
  final String field;
  final String path;
  final String filename;
  final String contentType;

  const MultipartFileData({
    required this.field,
    required this.path,
    required this.filename,
    this.contentType = 'application/pdf',
  });
}

class MultipartPayload {
  /// Campos de texto na ordem de envio. Chave repetida vira array.
  final List<MapEntry<String, String>> fields;
  final List<MultipartFileData> files;

  const MultipartPayload({this.fields = const [], this.files = const []});
}

class HttpUploadResponse {
  final int statusCode;
  final Map<String, String> headers; // chaves em minúsculas
  final dynamic data;

  const HttpUploadResponse({
    required this.statusCode,
    this.headers = const {},
    this.data,
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
