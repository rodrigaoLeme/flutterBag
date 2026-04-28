import 'dart:async';

import '../../../data/cache/cache.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../main/routes/routes.dart';
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
        image: 'lib/ui/assets/images/map_brasil.svg',
      ),
      OnboardingItem(
        title: strings.onboardingItem2Title,
        description: strings.onboardingItem2Description,
        image: 'lib/ui/assets/images/group_3.svg',
      ),
      OnboardingItem(
        title: strings.onboardingItem3Title,
        description: strings.onboardingItem3Description,
        image: 'lib/ui/assets/images/group_1.svg',
      ),
      OnboardingItem(
        title: strings.onboardingItem4Title,
        description: strings.onboardingItem4Description,
        image: 'lib/ui/assets/images/group_2.svg',
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
  void dispose() {
    _isAuthenticatedController.close();
    _currentPageIndexController.close();
    _navigationRouteController.close();
  }
}
