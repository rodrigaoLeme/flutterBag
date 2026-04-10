import '../../../app/core/endpoints/endpoints_v2_dev.dart';
import '../../../app/core/services/http_client/base/http_client.dart';
import '../../../domain/entities/result_documents_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/result_documents/load_result_documents.dart';
import '../../http/http_error.dart';
import '../../models/result_documents_model.dart';

class RemoteLoadResultDocuments implements LoadResultDocuments {
  final EndpointsV2Dev endpoints;
  final HttpClient httpClient;

  RemoteLoadResultDocuments(
      {required this.endpoints, required this.httpClient});

  @override
  Future<ResultDocumentsEntity?> load(String scholarshipId) async {
    try {
      ResultDocumentsEntity? resultEntity;

      final httpResponse = await httpClient.get(
        endpoints.processResultStudent(scholarshipId: scholarshipId),
      );
      httpResponse.fold(
        (exception) {
          throw exception;
        },
        (response) {
          resultEntity =
              ResultDocumentsModel.fromJson(response.data).toEntity();
        },
      );
      return resultEntity;
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
