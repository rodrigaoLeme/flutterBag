import 'dart:developer';

import 'package:either_dart/either.dart';

import '../../../domain/usecases/set_device_code/exceptions.dart';
import '../../../domain/usecases/set_device_code/params.dart';
import '../../../domain/usecases/set_device_code/repository.dart';
import '../../../domain/usecases/set_device_code/result_typedef.dart';
import 'datasource.dart';

class RepositoryImpl implements Repository {
  final Datasource _datasource;

  const RepositoryImpl(this._datasource);

  @override
  Result call(Params params) async {
    try {
      final result = await _datasource(params);
      return result;
    } on UsecaseException catch (e) {
      return Left(e);
    } catch (e) {
      log(e.toString(), error: e);
      return const Left(UnknownUsecaseException(message: 'Não foi configurar o código do dispositivo'));
    }
  }
}
