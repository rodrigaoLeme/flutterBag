import '../../../domain/usecases/forgot_password/entity.dart';
import '../../../domain/usecases/forgot_password/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
