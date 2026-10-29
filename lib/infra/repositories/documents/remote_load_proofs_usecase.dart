import '../../../data/http/http_client.dart';
import '../../../domain/entities/scholarship_proof_entity.dart';
import '../../../domain/usecases/documents/load_proofs_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadProofsUsecase implements LoadProofsUsecase {
  final HttpClient httpClient;

  const RemoteLoadProofsUsecase({required this.httpClient});

  @override
  Future<List<ScholarshipProofEntity>> load(String scholarshipId) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/v1/scholarships/$scholarshipId/proofs',
        method: HttpMethod.get,
      );

      return (response as List)
          .map((e) => ScholarshipProofEntity.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadProofsException(AppI18n.current.errorNoInternet);
      }
      throw LoadProofsException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadProofsException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}
