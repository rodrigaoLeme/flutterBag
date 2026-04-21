import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/authentication.dart';
import '../../../domain/usecases/account/save_current_account.dart';
import '../../../main/routes/routes.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/auth/login_presenter.dart';
import '../../mixins/mixins.dart';

class StreamLoginPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements LoginPresenter {
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  StreamLoginPresenter({
    required this.authentication,
    required this.saveCurrentAccount,
  });

  @override
  Future<void> auth({
    required String identifier,
    required String password,
  }) async {
    try {
      isLoading = LoadingData(isLoading: true);
      uiError = null;

      final account = await authentication.auth(
        AuthenticationParams(
          identifier: identifier,
          password: password,
        ),
      );

      await saveCurrentAccount.save(account.accessToken);
      navigateTo = NavigationData(route: Routes.home, clear: true);
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          uiError = 'CPF/CNPJ ou senha incorretos.';
        case DomainError.noInternetConnection:
          uiError = 'Sem conexão com a internet.';
        default:
          uiError = 'Erro inesperado. Tente novamente.';
      }
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

  @override
  void dispose() {}
}
