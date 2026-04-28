import 'package:cpf_cnpj_validator/cpf_validator.dart';

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

    final cleanCpf = params.identifier.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanCpf.isEmpty) {
      throw LoginValidationException(
        appStrings.loginValidationCpfRequired,
        field: 'cpf',
      );
    }
    if (!CPFValidator.isValid(cleanCpf)) {
      throw LoginValidationException(
        appStrings.loginValidationInvalidCpf,
        field: 'cpf',
      );
    }
    if (params.password.trim().isEmpty) {
      throw LoginValidationException(
        appStrings.loginValidationPasswordRequired,
        field: 'password',
      );
    }

    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/auth/login',
        method: HttpMethod.post,
        body: {
          'userName': cleanCpf,
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
      if (model.refreshTokenExpiryTime != null) {
        await secureStorage.save(
          key: StorageKeys.refreshTokenExpiryTime,
          value: model.refreshTokenExpiryTime!.toIso8601String(),
        );
      }

      return model.toEntity();
    } on ApiException catch (e) {
      switch (e.code) {
        case 'Identity.InvalidCredentials':
          throw InvalidCredentialsException(e.title);
        default:
          throw InvalidCredentialsException(AppI18n.current.invalidCredentials);
      }
    } on HttpError catch (e) {
      if (e == HttpError.unauthorized) {
        throw InvalidCredentialsException(AppI18n.current.invalidCredentials);
      }
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
        case 'User.ExistUser':
          throw InvalidCredentialsException(e.title);
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
  Future<ForgotPasswordResult> forgotPassword(
      ForgotPasswordUsecaseParams params) async {
    if (params.identifier.trim().isEmpty) {
      throw ForgotPasswordValidationException(
        AppI18n.current.forgotPasswordValidationCpfRequired,
      );
    }
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/account/forgot-password',
        method: HttpMethod.post,
        body: {'username': params.identifier.trim()},
      );

      final emailMasked = response['emailMasked'] as String? ?? '';
      return ForgotPasswordResult(emailMasked: emailMasked);
    } on ApiException catch (e) {
      throw ForgotPasswordValidationException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw ForgotPasswordValidationException(
            AppI18n.current.errorNoInternet);
      }
      throw ForgotPasswordValidationException(AppI18n.current.errorUnexpected);
    }
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
      await secureStorage.delete(key: StorageKeys.accessToken);
      await secureStorage.delete(key: StorageKeys.refreshToken);
      await secureStorage.delete(key: StorageKeys.refreshTokenExpiryTime);
    }
  }
}
