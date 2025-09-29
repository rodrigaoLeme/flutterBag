import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../domain/usecases/send_proof_document/exceptions.dart';
import '../../../domain/usecases/send_proof_document/params.dart';
import '../../../domain/usecases/send_proof_document/repository.dart';
import '../../../domain/usecases/send_proof_document/result_typedef.dart';
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
      return const Left(UnknownUsecaseException(message: 'Não foi possível enviar os documentos'));
    }
  }
}
