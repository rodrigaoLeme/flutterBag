import 'package:either_dart/either.dart';

import '../../../domain/usecases/get_processes_years/exceptions.dart';
import '../../../domain/usecases/get_processes_years/params.dart';
import '../../../domain/usecases/get_processes_years/repository.dart';
import '../../../domain/usecases/get_processes_years/result_typedef.dart';
import 'datasource.dart';

class RepositoryImpl implements Repository {
  final Datasource _datasource;

  RepositoryImpl(this._datasource);

  @override
  Result call(Params params) async {
    try {
      final result = await _datasource(params);
      return Right(result);
    } on UsecaseException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnknownUsecaseException(message: 'Não foi possível receber a lista de anos de processos'));
    }
  }
}
