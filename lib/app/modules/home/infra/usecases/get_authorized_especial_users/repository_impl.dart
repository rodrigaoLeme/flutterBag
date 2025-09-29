import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../domain/usecases/get_authorized_especial_users/exceptions.dart';
import '../../../domain/usecases/get_authorized_especial_users/params.dart';
import '../../../domain/usecases/get_authorized_especial_users/repository.dart';
import '../../../domain/usecases/get_authorized_especial_users/result_typedef.dart';
import 'datasource.dart';

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
      return Left(UnknownUsecaseException(
          message: 'Não foi possível receber o período de processo'));
    }
  }
}
