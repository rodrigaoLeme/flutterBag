import '../../../data/http/http_client.dart';
import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/enrollment_enums.dart';
import '../../../domain/entities/family_member_entity.dart';
import '../../../domain/entities/group_income_entity.dart';
import '../../../domain/entities/scholarship_form_entity.dart';
import '../../../domain/usecases/enrollment/load_scholarship_form_usecase.dart';
import '../../../main/flavors.dart';

class RemoteLoadScholarshipFormUsecase implements LoadScholarshipFormUsecase {
  final HttpClient httpClient;

  const RemoteLoadScholarshipFormUsecase({required this.httpClient});

  @override
  Future<ScholarshipFormEntity?> load(String scholarshipId) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/scholarships/$scholarshipId',
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
        groupIncome: _parseGroupIncome(json),
      );
    } on HttpError catch (e) {
      if (e == HttpError.notFound) return null; // 404
      rethrow;
    }
  }

  GroupIncomeEntity _parseGroupIncome(Map<String, dynamic> json) {
    return GroupIncomeEntity(
      hasRentalPropertyValues: json['hasRentalPropertyValues'] as bool?,
      propertysAmount: _parseDouble(json['propertysAmount']),
      financialHelpType: json['financialHelpType'] as int?,
      financialHelpAmount: _parseDouble(json['financialHelpAmount']),
      financialHelper: json['financialHelper'] as String?,
      isGovernmentBeneficiary: json['isGovernmentBeneficiary'] as bool?,
      governmentProgramDescription:
          json['governmentProgramDescription'] as String?,
      governmentProgramAmount: _parseDouble(json['governmentProgramAmount']),
      hasProprietys: json['hasProprietys'] as bool?,
      hasFinancing: json['hasFinancing'] as bool?,
      hasVehicles: json['hasVehicles'] as bool?,
      properties: (json['properties'] as List?)
              ?.map((e) =>
                  PropertyEntity.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      financings: (json['financings'] as List?)
              ?.map((e) =>
                  FinancingEntity.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      vehicles: (json['vehicles'] as List?)
              ?.map((e) =>
                  VehicleEntity.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
