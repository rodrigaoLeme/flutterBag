import '../../../domain/usecases/get_processes_years/entity.dart';
import '../../../domain/usecases/get_processes_years/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);
}
