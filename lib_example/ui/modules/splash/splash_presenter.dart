import '../../mixins/navigation_data.dart';

abstract class SplashPresenter {
  Stream<NavigationData?> get navigateToStream;

  Future<void> checkAccount();
}
