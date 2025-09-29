import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/get_document_by_file_id/entity.dart';
import '../../../domain/usecases/get_document_by_file_id/exceptions.dart';
import '../../../domain/usecases/get_document_by_file_id/params.dart';
import '../../../infra/usecases/get_document_by_file_id/datasource.dart';
import 'mapper.dart';

class DatasourceImplV2 implements Datasource {
  final HttpClient _client;
  final Mapper _mapper;
  final EndpointsV2Dev _endpoints;

  const DatasourceImplV2(this._client, this._mapper, this._endpoints);

  @override
  Future<Entity> call(Params params) async {
    late Entity entity;
    try {
      final result = await _client.get(
        _endpoints.file(fileId: params.fileId),
      );
      result.fold(
        (exception) {
          //TODO(adbysantos) Tratar as exceções de GetFileByFileId
          if (exception.message.contains('500')) {
            throw ServerException();
          }
          throw exception;
        },
        (response) {
          entity = _mapper.fromResponseToEntity(response.data);
        },
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }
}
