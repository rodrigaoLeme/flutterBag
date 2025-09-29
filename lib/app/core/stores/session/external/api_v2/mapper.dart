import 'package:either_dart/either.dart';
import 'package:localization/localization.dart';

import '../../../../entities/logged_user_v2.dart';
import '../../domain/refresh_token_exceptions.dart';

class RefreshTokenV2Mapper {
  Either<RefreshTokenException, LoggedUser> fromJsonToEntity(Map<String, dynamic> json) {
    try {
      final user = LoggedUser.fromJson(json);
      return Right(user);
    } catch (e) {
      return Left(UnknownTokenException(message: "refresh_token_mapper_unable_to_convert_json".i18n()));
    }
  }
}
