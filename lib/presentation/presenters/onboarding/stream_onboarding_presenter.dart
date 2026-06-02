import 'dart:async';

import '../../../data/cache/cache.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../main/routes/routes.dart';
import '../../../ui/helpers/themes/themes.dart';
import '../../../ui/modules/onboarding/onboarding_presenter.dart';

class StreamOnboardingPresenter implements OnboardingPresenter {
  final SecureStorage secureStorage;

  late final List<OnboardingItem> _items;

  StreamOnboardingPresenter({required this.secureStorage}) {
    final strings = AppI18n.current;
    _items = [
      OnboardingItem(
        title: strings.onboardingItem1Title,
        description: strings.onboardingItem1Description,
        image: AppImages.mapBrasil,
      ),
      OnboardingItem(
        title: strings.onboardingItem2Title,
        description: strings.onboardingItem2Description,
        image: AppImages.onboarding3,
      ),
      OnboardingItem(
        title: strings.onboardingItem3Title,
        description: strings.onboardingItem3Description,
        image: AppImages.onboarding1,
      ),
      OnboardingItem(
        title: strings.onboardingItem4Title,
        description: strings.onboardingItem4Description,
        image: AppImages.onboarding2,
      ),
    ];
  }

  final _isAuthenticatedController = StreamController<bool?>.broadcast();
  final _currentPageIndexController = StreamController<int>.broadcast();
  final _navigationRouteController = StreamController<String?>.broadcast();

  @override
  Stream<bool?> get isAuthenticatedStream => _isAuthenticatedController.stream;

  @override
  Stream<int> get currentPageIndexStream => _currentPageIndexController.stream;

  @override
  Stream<String?> get navigationRouteStream =>
      _navigationRouteController.stream;

  @override
  List<OnboardingItem> get items => _items;

  @override
  bool isLastPage(int index) => index == _items.length - 1;

  @override
  Future<void> nextPage(int currentIndex) async {
    if (isLastPage(currentIndex)) {
      await markTutorialAsSeen();
      _navigationRouteController.add(Routes.login);
    } else {
      _currentPageIndexController.add(currentIndex + 1);
    }
  }

  @override
  Future<void> checkSession() async {}

  @override
  Future<void> markTutorialAsSeen() async {
    await secureStorage.save(
      key: StorageKeys.hasSeenTutorial,
      value: 'true',
    );
  }

  @override
  void setCurrentPage(int index) {
    _currentPageIndexController.add(index);
  }

  @override
  void dispose() {
    _isAuthenticatedController.close();
    _currentPageIndexController.close();
    _navigationRouteController.close();
  }
}
