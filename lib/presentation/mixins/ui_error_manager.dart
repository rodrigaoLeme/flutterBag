import 'dart:async';

mixin UIErrorManager {
  final StreamController<String?> _uiErrorController =
      StreamController<String?>.broadcast();

  Stream<String?> get uiErrorStream => _uiErrorController.stream;

  set uiError(String? value) {
    if (!_uiErrorController.isClosed) {
      _uiErrorController.add(value);
    }
  }
}
