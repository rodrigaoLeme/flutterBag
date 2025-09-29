import '../../../domain/usecases/get_students_result_by_scholarship/entity.dart';
import '../../../domain/usecases/get_students_result_by_scholarship/params.dart';

/// Interface que define como buscar dados (sem saber de onde vem)
abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
