class HttpClientException {
  final String message;

  HttpClientException(this.message);

  @override
  String toString() => 'HttpClientException(message: $message)';
}
