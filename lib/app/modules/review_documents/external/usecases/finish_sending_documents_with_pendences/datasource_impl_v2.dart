import 'package:either_dart/either.dart';

import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/finish_sending_documents_with_pendences/entity.dart';
import '../../../domain/usecases/finish_sending_documents_with_pendences/exceptions.dart';
import '../../../domain/usecases/finish_sending_documents_with_pendences/params.dart';
import '../../../infra/usecases/finish_sending_documents_with_pendences/datasource.dart';

class DatasourceImplV2 implements Datasource {
  final HttpClient _client;
  final EndpointsV2Dev _endpoints;

  const DatasourceImplV2(this._client, this._endpoints);

  @override
  Future<Either<UsecaseException, Entity>> call(Params params) async {
    final result = await _client.put(
      _endpoints.finishSendingDocumentsWithPendences(
          scholarshipReviewId: params.scholarshipReviewId),
      data: {
        'ScholarshipId': params.scholarshipId,
        'scholarshipReviewId': params.scholarshipReviewId
      },
    );
    return result.fold(
      (exception) {
        if (exception.message.contains('500')) {
          return const Left(ServerException());
        }
        return Left(UnknownUsecaseException(message: exception.message));
      },
      (response) {
        return response.statusCode.toString().startsWith('2')
            ? const Right(Entity(response: true))
            : const Left(UnknownUsecaseException());
      },
    );
  }
}
