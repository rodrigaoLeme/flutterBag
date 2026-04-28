import '../../entities/user_entity.dart';

class LoginUsecaseParams {
  final String identifier;
  final String password;

  const LoginUsecaseParams({
    required this.identifier,
    required this.password,
  });
}

class CreateAccountUsecaseParams {
  final String name;
  final String email;
  final String cpf;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final bool termsOfUseAccepted;

  const CreateAccountUsecaseParams({
    required this.name,
    required this.email,
    required this.cpf,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.termsOfUseAccepted,
  });
}

class ForgotPasswordUsecaseParams {
  final String identifier;

  const ForgotPasswordUsecaseParams({required this.identifier});
}

abstract class LoginUsecase {
  Future<UserEntity> login(LoginUsecaseParams params);
}

abstract class CreateAccountUsecase {
  Future<UserEntity> createAccount(CreateAccountUsecaseParams params);
}

class ForgotPasswordResult {
  final String emailMasked;
  const ForgotPasswordResult({required this.emailMasked});
}

abstract class ForgotPasswordUsecase {
  Future<ForgotPasswordResult> forgotPassword(
      ForgotPasswordUsecaseParams params);
}

abstract class LogoutUsecase {
  Future<void> logout();
}

// Exceções de domínio
class LoginValidationException implements Exception {
  final String field;
  final String message;
  const LoginValidationException(this.message, {this.field = ''});
}

class CreateAccountValidationException implements Exception {
  final String field;
  final String message;
  const CreateAccountValidationException({
    required this.field,
    required this.message,
  });
}

class CreateAccountApiException implements Exception {
  final String type;
  const CreateAccountApiException(this.type);
}

class RateLimitException implements Exception {}

class EmailVerificationRequiredException implements Exception {}

class ForgotPasswordValidationException implements Exception {
  final String message;
  const ForgotPasswordValidationException(this.message);
}

class InvalidCredentialsException implements Exception {
  final String message;
  const InvalidCredentialsException(this.message);
}

class AccountAlreadyExistsException implements Exception {
  final String message;
  const AccountAlreadyExistsException([this.message = '']);
}
