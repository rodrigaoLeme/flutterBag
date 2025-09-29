class RefreshTokenClientException {
  final String message;

  RefreshTokenClientException(this.message);

  @override
  String toString() => 'RefreshTokenClientException(message: $message)';
}
