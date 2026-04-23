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
        value: model.accessToken,
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
    _validate(params);

    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/auth/register',
        method: HttpMethod.post,
        body: {
          'name': params.name.trim(),
          'email': params.email.trim().toLowerCase(),
          'cpf': params.cpf.replaceAll(RegExp(r'[^\d]'), ''),
          'password': params.password,
        },
      );

      final model = RemoteAuthModel.fromJson(
        Map<String, dynamic>.from(response as Map),
      );

      await secureStorage.save(
        key: StorageKeys.accessToken,
        value: model.accessToken,
      );
      await secureStorage.save(
        key: StorageKeys.refreshToken,
        value: model.refreshToken,
      );

      return model.toEntity();
    } on HttpError catch (e) {
      if (e == HttpError.badRequest) throw AccountAlreadyExistsException();
      rethrow;
    }
  }

  void _validate(CreateAccountUsecaseParams params) {
    final appStrings = AppI18n.current;
    final cleanCpf = params.cpf.replaceAll(RegExp(r'[^\d]'), '');
    if (!CPFValidator.isValid(cleanCpf)) {
      throw CreateAccountValidationException(
        field: 'cpf',
        message: appStrings.createAccountValidationInvalidCpf,
      );
    }
    if (params.name.trim().length < 3) {
      throw CreateAccountValidationException(
        field: 'name',
        message: appStrings.createAccountValidationFullNameRequired,
      );
    }
    if (!RegExp(r'^[\w.]+@[\w]+\.\w{2,}$').hasMatch(params.email.trim())) {
      throw CreateAccountValidationException(
        field: 'email',
        message: appStrings.createAccountValidationInvalidEmail,
      );
    }
    if (params.phone.trim().length < 15) {
      throw CreateAccountValidationException(
        field: 'phone',
        message: appStrings.createAccountValidationInvalidPhone,
      );
    }
    if (params.password.length < 8) {
      throw CreateAccountValidationException(
        field: 'password',
        message: appStrings.createAccountValidationPasswordMin,
      );
    }
    if (params.password != params.passwordConfirmation) {
      throw CreateAccountValidationException(
        field: 'passwordConfirmation',
        message: appStrings.createAccountValidationPasswordMismatch,
      );
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
