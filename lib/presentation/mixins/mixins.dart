import 'dart:async';

// ---------------------------------------------------------------------------
// LoadingManager
// ---------------------------------------------------------------------------
class LoadingData {
  final bool isLoading;
  const LoadingData({required this.isLoading});
}

mixin LoadingManager {
  final StreamController<LoadingData?> _isLoadingController =
      StreamController<LoadingData?>.broadcast();

  Stream<LoadingData?> get isLoadingStream => _isLoadingController.stream;

  set isLoading(LoadingData value) {
    if (!_isLoadingController.isClosed) {
      _isLoadingController.add(value);
    }
  }
}

// ---------------------------------------------------------------------------
// NavigationManager
// ---------------------------------------------------------------------------
class NavigationData {
  final String route;
  final dynamic arguments;
  const NavigationData({required this.route, this.arguments});
}

mixin NavigationManager {
  final StreamController<NavigationData?> _navigateToController =
      StreamController<NavigationData?>.broadcast();

  Stream<NavigationData?> get navigateToStream => _navigateToController.stream;

  set navigateTo(NavigationData value) {
    if (!_navigateToController.isClosed) {
      _navigateToController.add(value);
    }
  }
}

// ---------------------------------------------------------------------------
// UIErrorManager
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// SessionManager
// ---------------------------------------------------------------------------
mixin SessionManager {
  final StreamController<bool> _isSessionExpiredController =
      StreamController<bool>.broadcast();

  Stream<bool> get isSessionExpiredStream => _isSessionExpiredController.stream;

  set isSessionExpired(bool value) {
    if (!_isSessionExpiredController.isClosed) {
      _isSessionExpiredController.add(value);
    }
  }

  /// Deve ser chamado no dispose() do presenter que usa este mixin.
  void disposeSession() {
    if (!_isSessionExpiredController.isClosed) {
      _isSessionExpiredController.close();
    }
  }
}
