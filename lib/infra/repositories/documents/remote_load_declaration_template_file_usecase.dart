import '../../../data/http/http_client.dart';
import '../../../domain/entities/declaration_template_file_entity.dart';
import '../../../domain/usecases/documents/load_declaration_template_file_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadDeclarationTemplateFileUsecase
    implements LoadDeclarationTemplateFileUsecase {
  final HttpClient httpClient;

  const RemoteLoadDeclarationTemplateFileUsecase({required this.httpClient});

  @override
  Future<DeclarationTemplateFileEntity> load({
    required String scholarshipId,
    required String declarationTemplateId,
  }) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/v1/scholarships/$scholarshipId'
            '/declaration-templates/$declarationTemplateId/file',
        method: HttpMethod.get,
      );

      final data = Map<String, dynamic>.from(response as Map);
      final url = data['url'] as String?;
      if (url == null || url.isEmpty) {
        throw const LoadDeclarationTemplateFileException(
          'Modelo de declaração indisponível.',
        );
      }

      return DeclarationTemplateFileEntity(
        url: url,
        filename: _pdfName(data['filename'] as String?),
        contentType: data['contentType'] as String? ?? 'application/pdf',
      );
    } on LoadDeclarationTemplateFileException {
      rethrow;
    } on HttpError catch (e) {
      if (e == HttpError.notFound) {
        throw const LoadDeclarationTemplateFileException(
          'Modelo de declaração não encontrado ou indisponível.',
        );
      }
      if (e == HttpError.noConnectivity) {
        throw LoadDeclarationTemplateFileException(
          AppI18n.current.errorNoInternet,
        );
      }
      throw LoadDeclarationTemplateFileException(
        AppI18n.current.errorUnexpected,
      );
    } on ApiException catch (e) {
      throw LoadDeclarationTemplateFileException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }

  String _pdfName(String? name) {
    final value = (name == null || name.trim().isEmpty)
        ? 'modelo-declaracao'
        : name.trim();
    return value.toLowerCase().endsWith('.pdf') ? value : '$value.pdf';
  }
}
