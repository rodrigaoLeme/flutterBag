import '../../../domain/usecases/get_family_members_with_pendences_by_scholarship/entity.dart';
import '../../../domain/usecases/get_family_members_with_pendences_by_scholarship/params.dart';
import '../../../infra/usecases/get_family_members_with_pendences_by_scholarship/datasource.dart';

class DatasourceImplV2 implements Datasource {
  const DatasourceImplV2();

  @override
  Future<Entity> call(Params params) async {
    return Entity.empty();
  }
}
