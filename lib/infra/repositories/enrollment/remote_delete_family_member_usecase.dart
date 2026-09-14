import '../../../data/http/http_client.dart';
import '../../../domain/usecases/enrollment/delete_family_member_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteDeleteFamilyMemberUsecase implements DeleteFamilyMemberUsecase {
  final HttpClient httpClient;

  const RemoteDeleteFamilyMemberUsecase({required this.httpClient});

  @override
  Future<void> delete(DeleteFamilyMemberParams params) async {
    try {
      await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/scholarships/${params.scholarshipId}/step-2/family-members/${params.memberId}',
        method: HttpMethod.delete,
      );
    } on ApiException catch (e) {
      switch (e.code) {
        case 'FamilyMember.ScholarshipWithSocialProfile':
          throw DeleteFamilyMemberException(
            'Este processo já possui parecer social. A remoção deve ser feita pela unidade escolar.',
          );
        case 'FamilyMember.NotFound':
          throw DeleteFamilyMemberException('Membro não encontrado.');
        case 'Scholarship.NotFound':
          throw DeleteFamilyMemberException('Inscrição não encontrada.');
        default:
          throw DeleteFamilyMemberException(
            e.fullMessage.isNotEmpty
                ? e.fullMessage
                : AppI18n.current.errorUnexpected,
          );
      }
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw DeleteFamilyMemberException(AppI18n.current.errorNoInternet);
      }
      throw DeleteFamilyMemberException(AppI18n.current.errorUnexpected);
    }
  }
}
