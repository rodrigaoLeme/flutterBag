import '../../../data/http/http_client.dart';
import '../../../domain/entities/proof_document_file_url_entity.dart';
import '../../../domain/usecases/documents/load_proof_document_file_url_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadProofDocumentFileUrlUsecase
    implements LoadProofDocumentFileUrlUsecase {
  final HttpClient httpClient;

  RemoteLoadProofDocumentFileUrlUsecase({
    required this.httpClient,
  });

  @override
  Future<ProofDocumentFileUrlEntity> load({
    required String scholarshipId,
    required String proofDocumentId,
  }) async {
    try {
      final response = await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/scholarships/$scholarshipId/scholarship-proof-documents/$proofDocumentId/file',
        method: HttpMethod.get,
      );

      final data = Map<String, dynamic>.from(response as Map);
      final url = data['url'] as String?;
      if (url == null || url.isEmpty) {
        throw const LoadProofDocumentFileUrlException(
          'Arquivo indisponível.',
        );
      }

      return ProofDocumentFileUrlEntity(
        url: url,
        filename: _pdfName(data['filename'] as String?),
        contentType: data['contentType'] as String? ?? 'application/pdf',
      );
    } on LoadProofDocumentFileUrlException {
      rethrow;
    } on HttpError catch (e) {
      if (e == HttpError.notFound) {
        throw const LoadProofDocumentFileUrlException(
          'Arquivo não encontrado ou indisponível.',
        );
      }
      if (e == HttpError.noConnectivity) {
        throw LoadProofDocumentFileUrlException(
          AppI18n.current.errorNoInternet,
        );
      }
      throw LoadProofDocumentFileUrlException(
        AppI18n.current.errorUnexpected,
      );
    } on ApiException catch (e) {
      throw LoadProofDocumentFileUrlException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }

  String _pdfName(String? name) {
    final value =
        (name == null || name.trim().isEmpty) ? 'Imagens' : name.trim();
    return value.toLowerCase().endsWith('.pdf') ? value : '$value.pdf';
  }
}
