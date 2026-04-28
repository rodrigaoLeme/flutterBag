import 'dart:async';

import '../../../data/cache/cache.dart';
import '../../../main/routes/routes.dart';
import '../../../share/utils/jwt_decoder.dart';
import '../../../ui/modules/splash/splash_presenter.dart';

class StreamSplashPresenter implements SplashPresenter {
  final SecureStorage secureStorage;

  static const Duration minDuration = Duration(seconds: 3);
  static const Duration firstStageDuration = Duration(milliseconds: 1200);
  static const Duration crossFadeDuration = Duration(milliseconds: 700);
  static const Duration fadeDuration = Duration(milliseconds: 700);

  StreamSplashPresenter({required this.secureStorage});

  final _navigationController = StreamController<String?>.broadcast();
  final _showSecondLogoController = StreamController<bool>.broadcast();
  final _opacityController = StreamController<double>.broadcast();

  late final DateTime _startTime;

  @override
  Stream<String?> get navigationRouteStream => _navigationController.stream;

  @override
  Stream<bool> get showSecondLogoStream => _showSecondLogoController.stream;

  @override
  Stream<double> get opacityStream => _opacityController.stream;

  @override
  Future<void> checkSession() async {
    _startTime = DateTime.now();

    _scheduleShowSecondLogo();
    _scheduleNavigation();
  }

  void _scheduleShowSecondLogo() {
    Future.delayed(firstStageDuration, () {
      if (!_showSecondLogoController.isClosed) {
        _showSecondLogoController.add(true);
      }
    });
  }

  Future<void> _scheduleNavigation() async {
    await _ensureMinimumSplashTime();

    try {
      final token = await secureStorage.fetch(key: StorageKeys.accessToken);

      if (token != null && token.isNotEmpty) {
        if (JwtDecoder.isExpired(token)) {
          final refreshToken = await secureStorage.fetch(
            key: StorageKeys.refreshToken,
          );
          if (refreshToken == null || refreshToken.isEmpty) {
            await _clearSessionOnly();
          } else {
            await _fadeOutAndNavigate(Routes.home);
            return;
          }
        } else {
          await _fadeOutAndNavigate(Routes.home);
          return;
        }
      }

      final hasSeen =
          await secureStorage.fetch(key: StorageKeys.hasSeenTutorial);
      await _fadeOutAndNavigate(
          hasSeen == 'true' ? Routes.login : Routes.onboarding);
    } catch (_) {
      await _fadeOutAndNavigate(Routes.login);
    }
  }

  Future<void> _ensureMinimumSplashTime() async {
    final elapsed = DateTime.now().difference(_startTime);
    final remaining = minDuration - elapsed;

    if (!remaining.isNegative) {
      await Future.delayed(remaining);
    }
  }

  Future<void> _fadeOutAndNavigate(String route) async {
    if (!_opacityController.isClosed) {
      _opacityController.add(0.0);
    }
    await Future.delayed(fadeDuration);
    _emit(route);
  }

  void _emit(String route) {
    if (!_navigationController.isClosed) {
      _navigationController.add(route);
    }
  }

  Future<void> _clearSessionOnly() async {
    await secureStorage.delete(key: StorageKeys.accessToken);
    await secureStorage.delete(key: StorageKeys.refreshToken);
    await secureStorage.delete(key: StorageKeys.refreshTokenExpiryTime);
  }

  @override
  void dispose() {
    _navigationController.close();
    _showSecondLogoController.close();
    _opacityController.close();
  }
}
