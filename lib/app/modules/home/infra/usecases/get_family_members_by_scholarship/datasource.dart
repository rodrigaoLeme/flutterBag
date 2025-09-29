import '../../../domain/usecases/get_family_members_by_scholarship/entity.dart';
import '../../../domain/usecases/get_family_members_by_scholarship/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
