import '../../../data/http/http_client.dart';
import '../../../domain/usecases/candidate/delete_candidate_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteDeleteCandidateUsecase implements DeleteCandidateUsecase {
  final HttpClient httpClient;

  const RemoteDeleteCandidateUsecase({required this.httpClient});

  @override
  Future<void> delete(DeleteCandidateParams params) async {
    try {
      await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}/step-4/candidates/${params.studentId}',
        method: HttpMethod.delete,
      );
    } on ApiException catch (e) {
      final msg = e.code == 'Student.NotFound'
          ? 'Candidato não encontrado.'
          : e.fullMessage.isNotEmpty
              ? e.fullMessage
              : AppI18n.current.errorUnexpected;
      throw DeleteCandidateException(msg);
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw DeleteCandidateException(AppI18n.current.errorNoInternet);
      }
      throw DeleteCandidateException(AppI18n.current.errorUnexpected);
    }
  }
}
