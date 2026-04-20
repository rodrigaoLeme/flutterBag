import 'package:either_dart/either.dart';

import '../../../entities/logged_user_v2.dart';
import 'refresh_token_exceptions.dart';

typedef RefreshTokenResult = Future<Either<RefreshTokenException, LoggedUser>>;
