import '../../../domain/usecases/get_accepted_documents_by_proof/entity.dart';
import '../../../domain/usecases/get_accepted_documents_by_proof/params.dart';
import '../../../infra/usecases/get_accepted_documents_by_proof/datasource.dart';

class DatasourceImplV2 implements Datasource {
  const DatasourceImplV2();

  @override
  Future<Entity> call(Params params) async => Entity.empty();
}
