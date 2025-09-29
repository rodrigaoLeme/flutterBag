import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/forgot_password/entity.dart';
import '../../../domain/usecases/forgot_password/exceptions.dart';
import '../../../domain/usecases/forgot_password/params.dart';
import '../../../infra/datasources/forgot_password/datasource.dart';
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
      final result = await _client.post(
        _endpoints.forgotPassword,
        {"userName": params.id, "origin": "https://ebolsa.educadventista.org"},
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
