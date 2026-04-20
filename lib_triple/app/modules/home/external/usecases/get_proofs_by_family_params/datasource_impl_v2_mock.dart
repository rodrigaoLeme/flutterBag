import '../../../domain/usecases/get_proofs_by_family_params/entity.dart';
import '../../../domain/usecases/get_proofs_by_family_params/params.dart';
import '../../../infra/usecases/get_proofs_by_family_params/datasource.dart';

class DatasourceImplV2 implements Datasource {
  const DatasourceImplV2();

  @override
  Future<Entity> call(Params params) async => Entity.empty();
}
