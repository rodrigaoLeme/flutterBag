import '../../../main/i18n/app_i18n.dart';
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

  const CreateAccountUsecaseParams({
    required this.name,
    required this.email,
    required this.cpf,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
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

abstract class ForgotPasswordUsecase {
  Future<void> forgotPassword(ForgotPasswordUsecaseParams params);
}

abstract class LogoutUsecase {
  Future<void> logout();
}

// Exceções de domínio
class LoginValidationException implements Exception {
  final String message;
  const LoginValidationException(this.message);
}

class CreateAccountValidationException implements Exception {
  final String field;
  final String message;
  const CreateAccountValidationException({
    required this.field,
    required this.message,
  });
}

class ForgotPasswordValidationException implements Exception {
  final String message;
  const ForgotPasswordValidationException(this.message);
}

class InvalidCredentialsException implements Exception {
  final String message = AppI18n.current.invalidCredentials;
}

class AccountAlreadyExistsException implements Exception {
  final String message = AppI18n.current.accountAlreadyExists;
}
