import 'announcement_enums.dart';
import 'candidate_entity.dart';
import 'enrollment_enums.dart';
import 'expenses_entity.dart';
import 'family_member_entity.dart';
import 'group_income_entity.dart';

class ScholarshipFormEntity {
  final String? id; // Scholarship
  final String processPeriodId;
  final int currentStep;
  final int completedStep;
  final EducationLevel? educationLevel;

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
  final ExpensesEntity? expenses;

  // Step 4 - Candidatos
  final List<CandidateEntity> candidates;
  final String? announcementId;

  const ScholarshipFormEntity({
    this.id,
    required this.processPeriodId,
    this.currentStep = 1,
    this.completedStep = 0,
    this.educationLevel,
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
    this.expenses,
    this.candidates = const [],
    this.announcementId,
  });

  bool get hasScholarship => id != null;

  ScholarshipFormEntity copyWith({
    String? id,
    String? processPeriodId,
    int? currentStep,
    int? completedStep,
    EducationLevel? educationLevel,
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
    ExpensesEntity? expenses,
    List<CandidateEntity>? candidates,
    String? announcementId,
  }) =>
      ScholarshipFormEntity(
        id: id ?? this.id,
        processPeriodId: processPeriodId ?? this.processPeriodId,
        currentStep: currentStep ?? this.currentStep,
        completedStep: completedStep ?? this.completedStep,
        educationLevel: educationLevel ?? this.educationLevel,
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
        expenses: expenses ?? this.expenses,
        candidates: candidates ?? this.candidates,
        announcementId: announcementId ?? this.announcementId,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'processPeriodId': processPeriodId,
        'currentStep': currentStep,
        'completedStep': completedStep,
        'educationLevel': educationLevel?.value,
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
        'expenses': expenses?.toJson(),
        'candidates': candidates.map((e) => e.toJson()).toList(),
        'announcementId': announcementId,
      };

  factory ScholarshipFormEntity.fromJson(Map<String, dynamic> json) =>
      ScholarshipFormEntity(
        id: json['id'] as String?,
        processPeriodId: json['processPeriodId'] as String? ?? '',
        currentStep: json['currentStep'] as int? ?? 1,
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
        groupIncome: json['groupIncome'] != null
            ? GroupIncomeEntity.fromJson(
                Map<String, dynamic>.from(json['groupIncome'] as Map))
            : null,
        expenses: json['expenses'] != null
            ? ExpensesEntity.fromJson(
                Map<String, dynamic>.from(json['expenses'] as Map))
            : null,
        candidates: _parseCandidates(json),
        announcementId: json['announcementId'] as String? ??
            (json['announcement'] is Map
                ? (json['announcement'] as Map)['id'] as String?
                : null),
      );

  static List<CandidateEntity> _parseCandidates(Map<String, dynamic> json) {
    final raw =
        json['students'] ?? json['candidates'] ?? json['scholarshipCandidates'];
    if (raw is! List) return const [];
    return raw
        .map((e) =>
            CandidateEntity.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
