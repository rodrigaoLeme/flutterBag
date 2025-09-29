class HttpClientResponse {
  final dynamic data;
  final int statusCode;
  final String message;

  HttpClientResponse(this.data, this.statusCode, this.message);

  @override
  String toString() => 'HttpClientResponse(data: $data, statusCode: $statusCode, message: $message)';
}
