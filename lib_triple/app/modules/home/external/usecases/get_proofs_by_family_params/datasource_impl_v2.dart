import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/get_proofs_by_family_params/entity.dart';
import '../../../domain/usecases/get_proofs_by_family_params/exceptions.dart';
import '../../../domain/usecases/get_proofs_by_family_params/params.dart';
import '../../../infra/usecases/get_proofs_by_family_params/datasource.dart';
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
        _endpoints.proofs(scholarshipId: params.scholarshipId),
        queryParameters: _mapper.fromParamsToJson(params: params),
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
