import '../../../domain/usecases/get_document_by_file_id/entity.dart';
import '../../../domain/usecases/get_document_by_file_id/params.dart';
import '../../../infra/usecases/get_document_by_file_id/datasource.dart';

class DatasourceImplV2 implements Datasource {
  const DatasourceImplV2();

  @override
  Future<Entity> call(Params params) async => Entity.empty();
}
