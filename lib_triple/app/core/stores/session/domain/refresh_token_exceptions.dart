import '../../../exceptions/custom_exception.dart';

abstract class RefreshTokenException extends CustomException {
  RefreshTokenException({super.message, super.stackTrace});
}

class NullOrEmptyToken extends RefreshTokenException {
  NullOrEmptyToken({super.message, super.stackTrace});
}

class UnknownTokenException extends RefreshTokenException {
  UnknownTokenException({super.message, super.stackTrace});
}
