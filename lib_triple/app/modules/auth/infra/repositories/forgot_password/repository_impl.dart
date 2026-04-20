import 'dart:developer';

import 'package:either_dart/either.dart';
import 'package:localization/localization.dart';

import '../../../domain/usecases/forgot_password/exceptions.dart';
import '../../../domain/usecases/forgot_password/params.dart';
import '../../../domain/usecases/forgot_password/repository.dart';
import '../../../domain/usecases/forgot_password/result_typedef.dart';
import '../../datasources/forgot_password/datasource.dart';

class RepositoryImpl implements Repository {
  final Datasource _datasource;

  const RepositoryImpl(this._datasource);

  @override
  Result call(Params params) async {
    try {
      final result = await _datasource(params);
      return Right(result);
    } on UsecaseException catch (e) {
      return Left(e);
    } catch (e) {
      log(e.toString(), error: e);
      return Left(UnknownUsecaseException(message: _getLocalization('unknown_exception')));
    }
  }

  String _getLocalization(String attribute, {List<String>? params}) {
    return 'forgot_password_repository_$attribute'.i18n(params ?? []);
  }
}
