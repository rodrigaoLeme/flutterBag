import '../../../domain/usecases/send_proof_document/entity.dart';
import '../../../domain/usecases/send_proof_document/params.dart';
import '../../../infra/usecases/send_proof_document/datasource.dart';

class DatasourceImplV2 implements Datasource {
  const DatasourceImplV2();

  @override
  Future<Entity> call(Params params) async => Entity.empty();
}
