import 'package:either_dart/either.dart';

import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/set_scholarship_step/entity.dart';
import '../../../domain/usecases/set_scholarship_step/exceptions.dart';
import '../../../domain/usecases/set_scholarship_step/params.dart';
import '../../../infra/usecases/set_scholarship_step/datasource.dart';

class DatasourceImplV2 implements Datasource {
  final HttpClient _client;
  final EndpointsV2Dev _endpoints;

  const DatasourceImplV2(this._client, this._endpoints);

  @override
  Future<Either<UsecaseException, Entity>> call(Params params) async {
    final result = await _client.put(
      _endpoints.setScholarshipStep(
        processPeriodId: params.processPeriodId,
        scholarshipId: params.scholarshipId,
      ),
      data: '${params.step}',
    );
    return result.fold(
      (exception) {
        if (exception.message.contains('500')) {
          return const Left(ServerException());
        }
        return Left(UnknownUsecaseException(message: exception.message));
      },
      (response) => response.statusCode.toString().startsWith('2')
          ? const Right(Entity(response: true))
          : const Left(UnknownUsecaseException()),
    );
  }
}
