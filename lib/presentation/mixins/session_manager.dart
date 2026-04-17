import 'dart:async';

mixin SessionManager {
  final StreamController<bool> _isSessionExpiredController =
      StreamController<bool>.broadcast();

  Stream<bool> get isSessionExpiredStream => _isSessionExpiredController.stream;

  set isSessionExpired(bool value) {
    if (!_isSessionExpiredController.isClosed) {
      _isSessionExpiredController.add(value);
    }
  }
}
