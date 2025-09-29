import '../../../domain/usecases/get_students_by_scholarship_id/entity.dart';
import '../../../domain/usecases/get_students_by_scholarship_id/params.dart';
import '../../../infra/usecases/get_students_by_scholarship_id/datasource.dart';

class DatasourceImplV2 implements Datasource {
  const DatasourceImplV2();

  @override
  Future<Entity> call(Params params) async => Entity.empty();
}
