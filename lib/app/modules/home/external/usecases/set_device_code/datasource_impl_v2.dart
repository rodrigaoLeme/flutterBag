import 'package:either_dart/either.dart';

import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/set_device_code/entity.dart';
import '../../../domain/usecases/set_device_code/exceptions.dart';
import '../../../domain/usecases/set_device_code/params.dart';
import '../../../domain/usecases/set_device_code/result_typedef.dart';
import '../../../infra/usecases/set_device_code/datasource.dart';
import 'mapper.dart';

class DatasourceImplV2 extends Datasource {
  final HttpClient _client;
  final EndpointsV2Dev _endpoints;
  final Mapper mapper;

  const DatasourceImplV2(this._client, this._endpoints, this.mapper);

  @override
  Result call(Params params) async {
    final result = await _client.patch(
      _endpoints.setDeviceCode(nameIdentifier: params.nameidentifier),
      data: mapper.getDataFromParams(params),
    );
    return result.fold(
      (exception) {
        if (exception.message.contains('500')) {
          return Left(ServerException());
        }
        return const Left(UnknownUsecaseException());
      },
      (response) {
        return const Right(Entity(response: true));
      },
    );
  }
}
