import '../../../data/cache/cache.dart';
import '../../../data/http/http_client.dart';
import '../../../data/models/auth/remote_auth_model.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoginUsecase implements LoginUsecase {
  final HttpClient httpClient;
  final SecureStorage secureStorage;

  const RemoteLoginUsecase({
    required this.httpClient,
    required this.secureStorage,
  });

  @override
  Future<UserEntity> login(LoginUsecaseParams params) async {
    final appStrings = AppI18n.current;

    if (params.identifier.trim().isEmpty) {
      throw LoginValidationException(appStrings.loginValidationCpfRequired);
    }
    if (params.password.trim().isEmpty) {
      throw LoginValidationException(
          appStrings.loginValidationPasswordRequired);
    }

    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/auth/login',
        method: HttpMethod.post,
        body: {
          'identifier': params.identifier.trim(),
          'password': params.password,
        },
      );

      final model = RemoteAuthModel.fromJson(
        Map<String, dynamic>.from(response as Map),
      );

      await secureStorage.save(
        key: StorageKeys.accessToken,
        value: model.token,
      );
      await secureStorage.save(
        key: StorageKeys.refreshToken,
        value: model.refreshToken,
      );

      return model.toEntity();
    } on HttpError catch (e) {
      if (e == HttpError.unauthorized) throw InvalidCredentialsException();
      rethrow;
    }
  }
}

class RemoteCreateAccountUsecase implements CreateAccountUsecase {
  final HttpClient httpClient;
  final SecureStorage secureStorage;

  const RemoteCreateAccountUsecase({
    required this.httpClient,
    required this.secureStorage,
  });

  @override
  Future<UserEntity> createAccount(CreateAccountUsecaseParams params) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/auth/register',
        method: HttpMethod.post,
        body: {
          'cpf': params.cpf.replaceAll(RegExp(r'[^\d]'), ''),
          'fullName': params.name.trim(),
          'email': params.email.trim().toLowerCase(),
          'mobileNumber': params.phone.replaceAll(RegExp(r'[^\d]'), ''),
          'password': params.password,
          'passwordConfirmation': params.passwordConfirmation,
          'termsOfUseAccepted': params.termsOfUseAccepted,
        },
      );

      final model = RemoteAuthModel.fromJson(
        Map<String, dynamic>.from(response as Map),
      );

      await secureStorage.save(
        key: StorageKeys.accessToken,
        value: model.token,
      );
      await secureStorage.save(
        key: StorageKeys.refreshToken,
        value: model.refreshToken,
      );

      return model.toEntity();
    } on ApiException catch (e) {
      switch (e.code) {
        case 'User.ExistsUser':
          throw AccountAlreadyExistsException(e.title);
        case 'User.InvalidCpf':
          throw CreateAccountValidationException(
            field: 'cpf',
            message: e.title,
          );
        case 'User.EmailVerificationRequired':
          throw EmailVerificationRequiredException();
        case 'User.CreationFailed':
          throw CreateAccountValidationException(
            field: 'password',
            message: e.title,
          );
        case 'User.TermsOfUseRequired':
          throw CreateAccountValidationException(
            field: '',
            message: e.title,
          );
        default:
          throw CreateAccountValidationException(
            field: '',
            message: (e.title.isNotEmpty)
                ? e.title
                : AppI18n.current.errorUnexpected,
          );
      }
    } on HttpError catch (e) {
      if (e == HttpError.tooManyRequests) throw RateLimitException();
      rethrow;
    }
  }
}

class RemoteForgotPasswordUsecase implements ForgotPasswordUsecase {
  final HttpClient httpClient;

  const RemoteForgotPasswordUsecase({required this.httpClient});

  @override
  Future<void> forgotPassword(ForgotPasswordUsecaseParams params) async {
    if (params.identifier.trim().isEmpty) {
      throw ForgotPasswordValidationException(
        AppI18n.current.forgotPasswordValidationCpfRequired,
      );
    }
    await httpClient.request(
      url: '${Flavor.apiBaseUrl}/auth/forgot-password',
      method: HttpMethod.post,
      body: {'identifier': params.identifier.trim()},
    );
  }
}

class RemoteLogoutUsecase implements LogoutUsecase {
  final HttpClient httpClient;
  final SecureStorage secureStorage;

  const RemoteLogoutUsecase({
    required this.httpClient,
    required this.secureStorage,
  });

  @override
  Future<void> logout() async {
    try {
      await httpClient.request(
        url: '${Flavor.apiBaseUrl}/auth/logout',
        method: HttpMethod.post,
      );
    } catch (_) {
      // Segue limpando sessão local mesmo com erro na API
    } finally {
      await secureStorage.clean();
    }
  }
}
