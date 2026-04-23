import '../../../../domain/usecases/auth/auth_usecases.dart';
import '../../../../infra/repositories/auth/remote_auth_usecases.dart';
import '../../http/http_factories.dart';

// Casos de uso são stateless: recebem os singletons de infraestrutura
// via GetIt (via wrappers de factory) sem criar novas instâncias.

LoginUsecase makeRemoteLogin() => RemoteLoginUsecase(
      httpClient: makeDioAdapter(),
      secureStorage: makeSecureStorage(),
    );

CreateAccountUsecase makeRemoteCreateAccount() => RemoteCreateAccountUsecase(
      httpClient: makeDioAdapter(),
      secureStorage: makeSecureStorage(),
    );

ForgotPasswordUsecase makeRemoteForgotPassword() =>
    RemoteForgotPasswordUsecase(httpClient: makeDioAdapter());

LogoutUsecase makeRemoteLogout() => RemoteLogoutUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
      secureStorage: makeSecureStorage(),
    );
