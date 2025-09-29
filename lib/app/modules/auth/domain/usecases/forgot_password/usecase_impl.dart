import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:either_dart/either.dart';
import 'package:localization/localization.dart';

import 'exceptions.dart';
import 'repository.dart';
import 'result_typedef.dart';
import 'params.dart';
import 'usecase.dart';

class UsecaseImpl implements Usecase {
  final Repository _repository;

  const UsecaseImpl(this._repository);

  @override
  Result call(Params params) async {
    final idIsEmpty = params.id.isEmpty;
    if (idIsEmpty) {
      return Left(NotValidIdException(message: _getLocalization('empty_id_exception')));
    }
    if (!CPFValidator.isValid(params.id)) {
      return Left(NotValidIdException(message: _getLocalization('invalid_id_exception')));
    }
    return _repository(params);
  }

  String _getLocalization(String attribute, {List<String>? params}) {
    return 'login_with_id_usecase_$attribute'.i18n(params ?? []);
  }
}
