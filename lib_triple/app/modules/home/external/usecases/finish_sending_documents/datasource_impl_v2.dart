import 'package:either_dart/either.dart';

import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/finish_sending_documents/entity.dart';
import '../../../domain/usecases/finish_sending_documents/exceptions.dart';
import '../../../domain/usecases/finish_sending_documents/params.dart';
import '../../../infra/usecases/finish_sending_documents/datasource.dart';

class DatasourceImplV2 implements Datasource {
  final HttpClient _client;
  final EndpointsV2Dev _endpoints;

  const DatasourceImplV2(this._client, this._endpoints);

  @override
  Future<Either<UsecaseException, Entity>> call(Params params) async {
    final result = await _client.put(
      _endpoints.finishSendingDocuments(scholarshipId: params.scholarshipId),
    );
    return result.fold(
      (exception) {
        //TODO(adbysantos) Tratar as exceções de FinishSendingDocuments
        if (exception.message.contains('500')) {
          return const Left(ServerException());
        }
        return const Left(UnknownUsecaseException());
      },
      (response) {
        return response.statusCode.toString().startsWith('2')
            ? const Right(Entity(response: true))
            : const Left(UnknownUsecaseException());
      },
    );
  }
}
