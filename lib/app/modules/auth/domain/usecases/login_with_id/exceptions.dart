import '../../../../../core/exceptions/custom_exception.dart';

abstract class LoginWithIdException extends CustomException {
  const LoginWithIdException({String? message, StackTrace? stackTrace}) : super(message: message ?? '', stackTrace: stackTrace ?? StackTrace.empty);
}

class UnknownLoginWithIdException extends LoginWithIdException {
  const UnknownLoginWithIdException({required String message, required StackTrace stackTrace}) : super(message: message, stackTrace: stackTrace);
}

class NotValidFieldsException extends LoginWithIdException {
  final String? idMessage;
  final String? passwordMessage;
  const NotValidFieldsException({required this.idMessage, required this.passwordMessage});
}

class IncorrectCredentialsException extends LoginWithIdException {
  const IncorrectCredentialsException({required String message, required StackTrace stackTrace}) : super(message: message, stackTrace: stackTrace);
}

class MapperException extends LoginWithIdException {
  const MapperException({required String message, required StackTrace stackTrace}) : super(message: message, stackTrace: stackTrace);
}
