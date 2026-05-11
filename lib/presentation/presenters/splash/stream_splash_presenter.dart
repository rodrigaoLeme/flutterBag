import 'dart:async';

import '../../../data/cache/cache.dart';
import '../../../domain/entities/account_entity.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/di/injection_container.dart';
import '../../../main/routes/auth_routes.dart';
import '../../../main/routes/routes.dart';
import '../../../share/current_account.dart';
import '../../../share/utils/jwt_decoder.dart';
import '../../../ui/modules/splash/splash_presenter.dart';

class StreamSplashPresenter implements SplashPresenter {
  final SecureStorage secureStorage;
  final LoadAccountUsecase loadAccountUsecase;

  static const Duration minDuration = Duration(seconds: 3);
  static const Duration firstStageDuration = Duration(milliseconds: 1200);
  static const Duration crossFadeDuration = Duration(milliseconds: 700);
  static const Duration fadeDuration = Duration(milliseconds: 700);

  StreamSplashPresenter({
    required this.secureStorage,
    required this.loadAccountUsecase,
  });

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
            await _loadAccountAndNavigate();
            return;
          }
        } else {
          await _loadAccountAndNavigate();
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

  Future<void> _loadAccountAndNavigate() async {
    try {
      final account = await loadAccountUsecase.load();
      final saveCpf = await secureStorage.fetch(key: StorageKeys.userCpf) ?? '';

      sl<CurrentAccount>().set(
        AccountEntity(
          name: account.name,
          email: account.email,
          mobileNumber: account.mobileNumber,
          emailConfirmed: account.emailConfirmed,
          cpf: saveCpf,
        ),
      );

      final isPending = await secureStorage.fetch(
        key: StorageKeys.emailConfirmationPending,
      );

      if (isPending == 'true' || !account.emailConfirmed) {
        await _fadeOutAndNavigate(AuthRoutes.accountNotConfirmed);
        return;
      }

      await _fadeOutAndNavigate(Routes.home);
    } catch (_) {
      await _clearSessionOnly();
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
