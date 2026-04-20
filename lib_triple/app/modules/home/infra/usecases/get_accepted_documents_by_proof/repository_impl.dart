import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../domain/usecases/get_accepted_documents_by_proof/exceptions.dart';
import '../../../domain/usecases/get_accepted_documents_by_proof/params.dart';
import '../../../domain/usecases/get_accepted_documents_by_proof/repository.dart';
import '../../../domain/usecases/get_accepted_documents_by_proof/result_typedef.dart';
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
      return const Left(UnknownUsecaseException(message: 'Não foi possível receber os documentos aceitos'));
    }
  }
}
