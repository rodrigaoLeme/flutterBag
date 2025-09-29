abstract class SessionStoreExceptions {
  final String message;

  const SessionStoreExceptions(this.message);

  @override
  String toString() => message;
}

class TokenRefreshException extends SessionStoreExceptions {
  const TokenRefreshException(super.message);
}
