import '../../../domain/usecases/get_scholarship_by_period/entity.dart';
import '../../../domain/usecases/get_scholarship_by_period/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
