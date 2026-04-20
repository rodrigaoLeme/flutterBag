import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/exceptions.dart';
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/params.dart';
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/repository.dart';
import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/result_typedef.dart';
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
      return const Left(UnknownUsecaseException(message: 'Não foi possível receber os comprovantes com pendências'));
    }
  }
}
