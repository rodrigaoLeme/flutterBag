import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/get_processes_years/entity.dart';
import '../../../domain/usecases/get_processes_years/exceptions.dart';
import '../../../domain/usecases/get_processes_years/params.dart';
import '../../../infra/usecases/get_processes_years/datasource.dart';
import 'mapper.dart';

class DatasourceImplV2 implements Datasource {
  final HttpClient _client;
  final Mapper _mapper;
  final EndpointsV2Dev _endpoints;

  DatasourceImplV2(this._client, this._mapper, this._endpoints);

  @override
  Future<Entity> call(Params params) async {
    try {
      final result = await _client.get(_endpoints.processesYears);
      return result.fold(
        (exception) {
          //TODO(adbysantos) Tratar as exceções de GetProcessesYears
          if (exception.message.contains('500')) {
            throw ServerException();
          }
          throw exception;
        },
        (response) {
          return _mapper.fromListToEntity(response.data);
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
