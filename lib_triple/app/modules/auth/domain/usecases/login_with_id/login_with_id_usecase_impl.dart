import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:either_dart/either.dart';
import 'package:localization/localization.dart';

import 'exceptions.dart';
import 'login_with_id_usecase.dart';
import 'params.dart';
import 'repository.dart';
import 'result_typedef.dart';

class LoginWithIdUsecaseImpl implements LoginWithIdUsecase {
  final LoginWithIdRepository _repository;

  LoginWithIdUsecaseImpl(this._repository);

  @override
  LoginWithIdResult call(LoginWithIdParams params) async {
    final idIsEmpty = params.id.isEmpty;
    final passwordIsEmpty = params.password.isEmpty;

    if (idIsEmpty || passwordIsEmpty) {
      return Left(NotValidFieldsException(idMessage: idIsEmpty ? _getLocalization('empty_id_exception') : null, passwordMessage: passwordIsEmpty ? _getLocalization('empty_password_exception') : null));
    }
    if (!CPFValidator.isValid(params.id)) {
      return Left(NotValidFieldsException(idMessage: _getLocalization('invalid_id_exception'), passwordMessage: null));
    }
    return _repository(params);
  }
}

String _getLocalization(String attribute, {List<String>? params}) {
  return 'login_with_id_usecase_$attribute'.i18n(params ?? []);
}
