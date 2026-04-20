import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/get_authorized_especial_users/entity.dart';
import '../../../domain/usecases/get_authorized_especial_users/exceptions.dart';
import '../../../domain/usecases/get_authorized_especial_users/params.dart';
import '../../../infra/usecases/get_authorized_especial_users/datasource.dart';
import 'mapper.dart';

class DatasourceImplV2 implements Datasource {
  final HttpClient _client;
  final Mapper _mapper;
  final EndpointsV2Dev _endpoints;

  DatasourceImplV2(this._client, this._mapper, this._endpoints);

  @override
  Future<Entity> call(Params params) async {
    try {
      final result = await _client.get(_endpoints.authorizedEspecificUser(
          periodId: params.processPeriodId, userId: params.userId));

      return result.fold(
        (exception) {
          if (exception.message.contains('500')) {
            throw ServerException();
          }
          throw exception;
        },
        (response) => _mapper.fromMapToEntity(response.data),
      );
    } catch (e) {
      rethrow;
    }
  }
}
