import 'package:either_dart/either.dart';

import 'entity.dart';
import 'exceptions.dart';

/// Define que o resultado pode ser:
/// - Left: Exception (erro)
/// - Right: Entity (sucesso)
typedef Result = Future<Either<UsecaseException, Entity>>;
