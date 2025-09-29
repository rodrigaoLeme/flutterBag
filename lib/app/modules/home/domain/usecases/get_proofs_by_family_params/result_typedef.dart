import 'package:either_dart/either.dart';

import 'entity.dart';
import 'exceptions.dart';

typedef Result = Future<Either<UsecaseException, Entity>>;
