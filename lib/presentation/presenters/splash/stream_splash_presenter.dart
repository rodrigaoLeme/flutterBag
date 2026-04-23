import 'dart:async';

import '../../../data/cache/cache.dart';
import '../../../share/utils/jwt_decoder.dart';
import '../../../ui/modules/splash/splash_presenter.dart';

class StreamSplashPresenter implements SplashPresenter {
  final SecureStorage secureStorage;

  StreamSplashPresenter({required this.secureStorage});

  final _isAuthenticatedController = StreamController<bool?>.broadcast();

  @override
  Stream<bool?> get isAuthenticatedStream => _isAuthenticatedController.stream;

  @override
  Future<void> checkSession() async {
    try {
      final token = await secureStorage.fetch(key: StorageKeys.accessToken);

      if (token == null || token.isEmpty) {
        _emit(false);
        return;
      }

      if (JwtDecoder.isExpired(token)) {
        final refreshToken = await secureStorage.fetch(
          key: StorageKeys.refreshToken,
        );
        if (refreshToken == null || refreshToken.isEmpty) {
          await secureStorage.clean();
          _emit(false);
          return;
        }
      }

      _emit(true);
    } catch (_) {
      _emit(false);
    }
  }

  void _emit(bool value) {
    if (!_isAuthenticatedController.isClosed) {
      _isAuthenticatedController.add(value);
    }
  }

  @override
  void dispose() => _isAuthenticatedController.close();
}
