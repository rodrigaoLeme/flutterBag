import '../../../domain/usecases/forgot_password/entity.dart';
import '../../../domain/usecases/forgot_password/params.dart';
import '../../../infra/datasources/forgot_password/datasource.dart';

class DatasourceImplV2 implements Datasource {
  const DatasourceImplV2();

  @override
  Future<Entity> call(Params params) async => Entity.empty();
}
