import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../../../core/services/http_client/base/http_client_content_type.dart';
import '../../../domain/usecases/send_proof_document/entity.dart';
import '../../../domain/usecases/send_proof_document/exceptions.dart';
import '../../../domain/usecases/send_proof_document/params.dart';
import '../../../infra/usecases/send_proof_document/datasource.dart';

class DatasourceImplV2 implements Datasource {
  final HttpClient _client;
  final EndpointsV2Dev _endpoints;

  const DatasourceImplV2(this._client, this._endpoints);

  @override
  Future<Entity> call(Params params) async {
    late Entity entity;
    try {
      String fileName = params.file.path.split('/').last;
      final multipartFile = _client.multipartFileFromFileSync(
          path: params.file.path,
          filename: fileName,
          contentType: ContentType.pdf);
      final result = await _client.put(
        _endpoints.sendProofDocument(
            scholarshipProofDocumentId: params.scholarshipProofDocumentId),
        data: _client.fromMap(
          {
            'Files': multipartFile,
            'ScholarshipProofDocumentId': params.scholarshipProofDocumentId,
            'DocumentId': params.documentId,
            'AcceptTerm': params.acceptTerm,
            'origin': params.origin,
          },
        ),
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
          if (response.statusCode.toString().startsWith('2')) {
            entity = const Entity(sentFile: '');
          }
        },
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }
}
