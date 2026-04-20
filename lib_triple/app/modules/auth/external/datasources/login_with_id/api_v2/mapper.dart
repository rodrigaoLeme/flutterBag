import 'package:either_dart/either.dart';
import 'package:localization/localization.dart';

import '../../../../../../core/entities/logged_user_v2.dart';
import '../../../../domain/usecases/login_with_id/exceptions.dart';

class LoginWithIdDatasourceMapperV2 {
  Either<MapperException, LoggedUser> fromDataToEntity(dynamic data) {
    try {
      final user = LoggedUser.fromJson(data);
      return Right(user);
    } catch (e, stackTrace) {
      return Left(MapperException(message: "login_with_id_mapper_unable_to_convert_json".i18n(), stackTrace: stackTrace));
    }
  }
}
