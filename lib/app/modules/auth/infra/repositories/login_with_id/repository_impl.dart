import 'package:either_dart/either.dart';
import 'package:localization/localization.dart';

import '../../../domain/usecases/login_with_id/exceptions.dart';
import '../../../domain/usecases/login_with_id/params.dart';
import '../../../domain/usecases/login_with_id/repository.dart';
import '../../../domain/usecases/login_with_id/result_typedef.dart';
import '../../datasources/login_with_id_datasource.dart';

class LoginWithIdRepositoryImpl implements LoginWithIdRepository {
  final LoginWithIdDatasource _datasource;

  LoginWithIdRepositoryImpl(this._datasource);

  @override
  LoginWithIdResult call(LoginWithIdParams params) async {
    try {
      final result = await _datasource(params);
      return Right(result);
    } on LoginWithIdException catch (knownException) {
      return Left(knownException);
    } catch (unknownException, stackTrace) {
      return Left(UnknownLoginWithIdException(message: "login_with_id_repository_unknown_exception".i18n(), stackTrace: stackTrace));
    }
  }
}
