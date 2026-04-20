import '../../../domain/usecases/send_proof_document_with_pendences/entity.dart';
import '../../../domain/usecases/send_proof_document_with_pendences/params.dart';
import '../../../infra/usecases/send_proof_document_with_pendences/datasource.dart';

class DatasourceImplV2 implements Datasource {
  const DatasourceImplV2();

  @override
  Future<Entity> call(Params params) async => const Entity();
}
