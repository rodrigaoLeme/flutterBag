import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/exceptions.dart';
import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/params.dart';
import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/repository.dart';
import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/result_typedef.dart';
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
      return const Left(UnknownUsecaseException(message: 'Não foi possível recuperar a última revisão do processo em questão'));
    }
  }
}
