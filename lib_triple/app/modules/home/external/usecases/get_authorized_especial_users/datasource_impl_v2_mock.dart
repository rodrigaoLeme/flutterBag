import '../../../domain/usecases/get_authorized_especial_users/entity.dart';
import '../../../domain/usecases/get_authorized_especial_users/params.dart';
import '../../../infra/usecases/get_authorized_especial_users/datasource.dart';

class DatasourceImplV2Mock implements Datasource {
  const DatasourceImplV2Mock();

  @override
  Future<Entity> call(Params params) async {
    return const Entity('UM_ID');
  }
}
