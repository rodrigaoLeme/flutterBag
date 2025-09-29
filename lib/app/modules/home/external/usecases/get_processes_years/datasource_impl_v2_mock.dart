import '../../../domain/usecases/get_processes_years/entity.dart';
import '../../../domain/usecases/get_processes_years/params.dart';
import '../../../infra/usecases/get_processes_years/datasource.dart';

class DatasourceImplV2Mock implements Datasource {
  const DatasourceImplV2Mock();

  @override
  Future<Entity> call(Params params) async {
    return const Entity([
      2022
    ]);
  }
}
