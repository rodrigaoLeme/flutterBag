import '../../../data/http/http_client.dart';
import '../../../domain/entities/candidate_entity.dart';
import '../../../domain/usecases/enrollment/save_step_4_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteSaveStep4Usecase implements SaveStep4Usecase {
  final HttpClient httpClient;

  const RemoteSaveStep4Usecase({
    required this.httpClient,
  });

  @override
  Future<void> save(SaveStep4Params params) async {
    try {
      if (params.candidates.isEmpty) {
        throw const SaveStep4Exception(
          'Nenhum candidato foi cadastrado. Adicione os candidatos antes de confirmar esta etapa.',
        );
      }

      for (final candidate in params.candidates) {
        await _createStudent(
          scholarshipId: params.scholarshipId,
          candidate: candidate,
          educationLevel: params.educationLevel,
        );
      }

      await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}/step-4',
        method: HttpMethod.put,
        body: const {},
      );
    } on SaveStep4Exception {
      rethrow;
    } on ApiException catch (e) {
      throw SaveStep4Exception(
        e.fullMessage.isNotEmpty
            ? e.fullMessage
            : AppI18n.current.errorUnexpected,
      );
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw SaveStep4Exception(AppI18n.current.errorNoInternet);
      }
      throw SaveStep4Exception(AppI18n.current.errorUnexpected);
    }
  }

  Future<void> _createStudent({
    required String scholarshipId,
    required CandidateEntity candidate,
    int? educationLevel,
  }) async {
    final body = candidate.toStudentRequestBody(
      educationLevel: educationLevel,
    );
    final base = '${Flavor.apiBaseUrl}/v1/scholarships/$scholarshipId';

    final urls = [
      '$base/step-4/students',
      '$base/step-4/candidates',
      '$base/students',
    ];

    for (final url in urls) {
      if (await _tryPost(url: url, body: body)) return;
    }

    throw const SaveStep4Exception(
      'Não foi possível cadastrar o candidato. Tente novamente.',
    );
  }

  Future<bool> _tryPost({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    try {
      await httpClient.request(
        url: url,
        method: HttpMethod.post,
        body: body,
      );
      return true;
    } on HttpError catch (e) {
      if (e == HttpError.notFound) return false;
      rethrow;
    } on ApiException catch (e) {
      if (e.statusCode == 404) return false;
      if (e.statusCode == 409) return true;
      final code = e.code.toLowerCase();
      if (code.contains('already') || code.contains('exists')) return true;
      rethrow;
    }
  }
}

class SaveStep4Exception implements Exception {
  final String message;
  const SaveStep4Exception(this.message);
}
