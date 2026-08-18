import '../../../data/http/http_client.dart';
import '../../../domain/usecases/enrollment/save_family_member_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteSaveFamilyMemberUsecase implements SaveFamilyMemberUsecase {
  final HttpClient httpClient;

  const RemoteSaveFamilyMemberUsecase({required this.httpClient});

  @override
  Future<String> save(SaveFamilyMemberParams params) async {
    try {
      final member = params.member;
      final hasId = member.id != null;

      final response = await httpClient.request(
        url: hasId
            ? '${Flavor.apiBaseUrl}/scholarships/${params.scholarshipId}/step-2/family-members/${member.id}'
            : '${Flavor.apiBaseUrl}/scholarships/${params.scholarshipId}/step-2/family-members',
        method: hasId ? HttpMethod.put : HttpMethod.post,
        body: member.toJson(),
      );

      return hasId ? member.id! : response['id'] as String;
    } on ApiException catch (e) {
      throw SaveFamilyMemberException(
        e.fullMessage.isNotEmpty
            ? e.fullMessage
            : AppI18n.current.errorUnexpected,
      );
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw SaveFamilyMemberException(AppI18n.current.errorNoInternet);
      }
      throw SaveFamilyMemberException(AppI18n.current.errorUnexpected);
    }
  }
}

class SaveFamilyMemberException implements Exception {
  final String message;
  const SaveFamilyMemberException(this.message);
}
