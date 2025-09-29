import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../domain/usecases/get_students_result_by_scholarship/exceptions.dart';
import '../../../domain/usecases/get_students_result_by_scholarship/params.dart';
import '../../../domain/usecases/get_students_result_by_scholarship/repository.dart';
import '../../../domain/usecases/get_students_result_by_scholarship/result_typedef.dart';
import 'datasource.dart';

class RepositoryImpl implements Repository {
  final Datasource _datasource;

  const RepositoryImpl(this._datasource);

  @override
  Result call(Params params) async {
    try {
      // Tenta buscar os dados
      final result = await _datasource(params);
      return Right(result); // Sucesso!
    } on UsecaseException catch (e) {
      // Se for uma exceção conhecida, retorna ela
      return Left(e);
    } catch (e) {
      // Se for uma exceção desconhecida, loga e retorna erro genérico
      log('Erro ao buscar resultado: ${e.toString()}', error: e);
      return const Left(
        UnknownUsecaseException(
          message: 'Não foi possível carregar o resultado',
        ),
      );
    }
  }
}
