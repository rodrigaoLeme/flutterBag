import '../../../domain/usecases/get_process_periods/entity.dart';
import '../../../domain/usecases/get_process_periods/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
