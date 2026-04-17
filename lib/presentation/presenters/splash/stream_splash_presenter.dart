import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/load_current_account.dart';
import '../../../main/routes/routes.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/splash/splash_presenter.dart';
import '../../mixins/mixins.dart';

class StreamSplashPresenter with NavigationManager implements SplashPresenter {
  final LoadCurrentAccount loadCurrentAccount;

  StreamSplashPresenter({required this.loadCurrentAccount});

  @override
  Future<void> checkAccount() async {
    try {
      final account = await loadCurrentAccount.load();
      if (account != null) {
        navigateTo = NavigationData(route: Routes.home, clear: true);
      } else {
        navigateTo = NavigationData(route: Routes.login, clear: true);
      }
    } on DomainError {
      navigateTo = NavigationData(route: Routes.login, clear: true);
    } catch (_) {
      navigateTo = NavigationData(route: Routes.login, clear: true);
    }
  }
}
