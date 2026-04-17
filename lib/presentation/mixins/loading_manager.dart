import 'dart:async';

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
