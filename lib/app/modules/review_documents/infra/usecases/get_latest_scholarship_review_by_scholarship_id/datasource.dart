import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/entity.dart';
import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/params.dart';

abstract class Datasource {
  Future<Entity> call(Params params);

  const Datasource();
}
