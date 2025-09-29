import '../../../domain/usecases/get_authorized_especial_users/entity.dart';
import '../../../domain/usecases/get_authorized_especial_users/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
