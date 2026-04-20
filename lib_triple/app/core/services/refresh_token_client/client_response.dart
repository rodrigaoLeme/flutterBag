class RefreshTokenClientResponse {
  final dynamic data;
  final int statusCode;
  final String message;

  RefreshTokenClientResponse(this.data, this.statusCode, this.message);

  @override
  String toString() => 'RefreshTokenClientResponse(data: $data, statusCode: $statusCode, message: $message)';
}
