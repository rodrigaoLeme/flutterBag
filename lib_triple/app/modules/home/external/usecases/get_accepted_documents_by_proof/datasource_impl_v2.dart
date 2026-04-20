import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/get_accepted_documents_by_proof/entity.dart';
import '../../../domain/usecases/get_accepted_documents_by_proof/exceptions.dart';
import '../../../domain/usecases/get_accepted_documents_by_proof/params.dart';
import '../../../infra/usecases/get_accepted_documents_by_proof/datasource.dart';
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
        _endpoints.acceptedDocumentsByProof(
            entityProofItemId: params.entityProofItemId),
      );
      result.fold(
        (exception) {
          //TODO(adbysantos) Tratar as exceções de GetProofsByFamilyParams
          if (exception.message.contains('500')) {
            throw ServerException();
          }
          throw exception;
        },
        (response) {
          entity = _mapper.fromListToEntity(response.data);
        },
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }
}
