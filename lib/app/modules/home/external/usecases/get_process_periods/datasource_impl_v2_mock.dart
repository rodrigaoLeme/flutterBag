import '../../../domain/usecases/get_process_periods/entity.dart';
import '../../../domain/usecases/get_process_periods/params.dart';
import '../../../infra/usecases/get_process_periods/datasource.dart';

class DatasourceImplV2 implements Datasource {
  const DatasourceImplV2();

  @override
  Future<Entity> call(Params params) async {
    return Entity(processes: [
      Process.empty()
    ]);
  }
}
