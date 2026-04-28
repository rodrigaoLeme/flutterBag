import 'dart:async';

import '../../../data/cache/cache.dart';
import '../../../ui/modules/onboarding/onboarding_presenter.dart';

class StreamOnboardingPresenter implements OnboardingPresenter {
  final SecureStorage secureStorage;

  StreamOnboardingPresenter({required this.secureStorage});

  final _isAuthenticatedController = StreamController<bool?>.broadcast();

  @override
  Stream<bool?> get isAuthenticatedStream => _isAuthenticatedController.stream;

  @override
  Future<void> checkSession() async {}

  @override
  void dispose() => _isAuthenticatedController.close();
}
