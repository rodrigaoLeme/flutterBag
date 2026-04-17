import '../../../../domain/usecases/auth/auth_usecases.dart';
import '../../../../infra/repositories/auth/remote_auth_usecases.dart';
import '../../http/http_factories.dart';

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
