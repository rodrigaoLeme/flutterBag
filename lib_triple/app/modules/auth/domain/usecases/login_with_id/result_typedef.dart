import 'package:either_dart/either.dart';

import '../../../../../core/entities/logged_user_v2.dart';
import 'exceptions.dart';

typedef LoginWithIdResult = Future<Either<LoginWithIdException, LoggedUser>>;
