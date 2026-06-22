import 'package:either_dart/either.dart';

import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/finish_sending_documents/entity.dart';
import '../../../domain/usecases/finish_sending_documents/exceptions.dart';
import '../../../domain/usecases/finish_sending_documents/params.dart';
import '../../../infra/usecases/finish_sending_documents/datasource.dart';
import 'mapper.dart';

class DatasourceImplV2 implements Datasource {
  final HttpClient _client;
  final EndpointsV2Dev _endpoints;
  final Mapper mapper;

  const DatasourceImplV2(this._client, this._endpoints, this.mapper);

  @override
  Future<Either<UsecaseException, Entity>> call(Params params) async {
    final result = await _client.put(
      _endpoints.finishSendingDocuments(scholarshipId: params.scholarshipId),
      data: mapper.getDataFromParams(params),
    );
    return result.fold(
      (exception) {
        //TODO(adbysantos) Tratar as exceções de FinishSendingDocuments
        if (exception.message.contains('500')) {
          return const Left(ServerException());
        }
        return Left(UnknownUsecaseException(message: exception.message));
      },
      (response) {
        if (response.statusCode.toString().startsWith('2')) {
          return const Right(Entity(response: true));
        }

        // Captura a mensagem específica do backend quando disponível
        String? errorMessage;
        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          errorMessage = data['title'] ?? data['detail'] ?? data['message'];
        }

        return Left(UnknownUsecaseException(message: errorMessage));
      },
    );
  }
}
