import '../../../domain/usecases/get_scholarship_by_period/entity.dart';
import '../../../domain/usecases/get_scholarship_by_period/params.dart';
import '../../../infra/usecases/get_scholarship_by_period/datasource.dart';

class DatasourceImplV2 implements Datasource {
  const DatasourceImplV2();

  @override
  Future<Entity> call(Params params) async {
    return Entity.empty();
  }
}
