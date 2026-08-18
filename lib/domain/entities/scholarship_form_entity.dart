import 'enrollment_enums.dart';
import 'family_member_entity.dart';
import 'group_income_entity.dart';

class ScholarshipFormEntity {
  final String? id; // Scholarship
  final String processPeriodId;
  final int currentStep;
  final int completedStep;

  // Step 1 - Moradia
  final String? zipCode;
  final String? street;
  final String? number;
  final String? complement;
  final String? district;
  final String? city;
  final String? state;
  final ResidenceType? residenceType;
  final ResidenceAreaType? residenceAreaType;

  // Step 2 - Família
  final List<FamilyMemberEntity> familyMembers;
  final GroupIncomeEntity? groupIncome;

  // Step 3 - Despesas
  // Step 4 - Candidatos

  const ScholarshipFormEntity({
    this.id,
    required this.processPeriodId,
    this.currentStep = 1,
    this.completedStep = 0,
    this.zipCode,
    this.street,
    this.number,
    this.complement,
    this.district,
    this.city,
    this.state,
    this.residenceType,
    this.residenceAreaType,
    this.familyMembers = const [],
    this.groupIncome,
  });

  bool get hasScholarship => id != null;

  ScholarshipFormEntity copyWith({
    String? id,
    String? processPeriodId,
    int? currentStep,
    int? completedStep,
    String? zipCode,
    String? street,
    String? number,
    String? complement,
    String? district,
    String? city,
    String? state,
    ResidenceType? residenceType,
    ResidenceAreaType? residenceAreaType,
    List<FamilyMemberEntity>? familyMembers,
    GroupIncomeEntity? groupIncome,
  }) =>
      ScholarshipFormEntity(
        id: id ?? this.id,
        processPeriodId: processPeriodId ?? this.processPeriodId,
        currentStep: currentStep ?? this.currentStep,
        completedStep: completedStep ?? this.completedStep,
        zipCode: zipCode ?? this.zipCode,
        street: street ?? this.street,
        number: number ?? this.number,
        complement: complement ?? this.complement,
        district: district ?? this.district,
        city: city ?? this.city,
        state: state ?? this.state,
        residenceType: residenceType ?? this.residenceType,
        residenceAreaType: residenceAreaType ?? this.residenceAreaType,
        familyMembers: familyMembers ?? this.familyMembers,
        groupIncome: groupIncome ?? this.groupIncome,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'processPeriodId': processPeriodId,
        'currentStep': currentStep,
        'completedStep': completedStep,
        'zipCode': zipCode,
        'street': street,
        'number': number,
        'complement': complement,
        'district': district,
        'city': city,
        'state': state,
        'residenceType': residenceType?.value,
        'residenceAreaType': residenceAreaType?.value,
        'familyMembers': familyMembers.map((e) => e.toJson()).toList(),
        'groupIncome': groupIncome?.toJson(),
      };

  factory ScholarshipFormEntity.fromJson(Map<String, dynamic> json) =>
      ScholarshipFormEntity(
        id: json[''] as String?,
        processPeriodId: json['processPeriodId'] as String? ?? '',
        currentStep: json['currentStep'] as int? ?? 1,
        completedStep: json['completedStep'] as int? ?? 0,
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
        groupIncome: json['groupIncome'] != null
            ? GroupIncomeEntity.fromJson(
                Map<String, dynamic>.from(json['groupIncome'] as Map))
            : null,
      );
}
