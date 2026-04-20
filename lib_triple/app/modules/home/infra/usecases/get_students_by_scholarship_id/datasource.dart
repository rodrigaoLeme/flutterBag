import '../../../domain/usecases/get_students_by_scholarship_id/entity.dart';
import '../../../domain/usecases/get_students_by_scholarship_id/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
