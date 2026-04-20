import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../domain/usecases/get_scholarship_by_period/exceptions.dart';
import '../../../domain/usecases/get_scholarship_by_period/params.dart';
import '../../../domain/usecases/get_scholarship_by_period/repository.dart';
import '../../../domain/usecases/get_scholarship_by_period/result_typedef.dart';
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
      return Left(UnknownUsecaseException(message: 'Não foi possível receber a bolsa'));
    }
  }
}
