import '../../../data/http/http_client.dart';
import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/enrollment_enums.dart';
import '../../../domain/entities/family_member_entity.dart';
import '../../../domain/entities/scholarship_form_entity.dart';
import '../../../domain/usecases/enrollment/load_scholarship_form_usecase.dart';
import '../../../main/flavors.dart';

class RemoteLoadScholarshipFormUsecase implements LoadScholarshipFormUsecase {
  final HttpClient httpClient;

  const RemoteLoadScholarshipFormUsecase({required this.httpClient});

  @override
  Future<ScholarshipFormEntity?> load(String processPeriodId) async {
    try {
      final response = await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/process-periods/$processPeriodId/scholarship',
        method: HttpMethod.get,
      );

      final json = Map<String, dynamic>.from(response as Map);

      return ScholarshipFormEntity(
        id: json['id'] as String?,
        processPeriodId: json['processPeriodId'],
        // lógica para adaptar currentStep null em 0 e add + 1
        currentStep: (json['currentStep'] as int? ?? 0) + 1,
        completedStep: json['completedStep'] as int? ?? 0,
        educationLevel:
            EducationLevel.fromValue(json['educationLevel'] as int? ?? 0),
        zipCode: json['zipCode'] as String?,
        street: json['street'] as String?,
        number: json['number'] as String?,
        complement: json['complement'] as String?,
        district: json['district'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        residenceType: ResidenceType.fromValue(json['residenceType'] as int?),
        residenceAreaType:
            ResidenceAreaType.fromValue(json['residenceAreaType'] as int?),
        familyMembers: (json['familyMembers'] as List?)
                ?.map((e) => FamilyMemberEntity.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );
    } on HttpError catch (e) {
      if (e == HttpError.notFound) return null; // 404
      rethrow;
    }
  }
}
