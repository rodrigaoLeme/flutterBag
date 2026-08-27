import 'occupation_entity.dart';

class FamilyMemberEntity {
  final String? id;
  final String? name;
  final String? personCpf;
  final DateTime? personBirthDate;
  final int? personGender;
  final int kinshipType;
  final int maritalStatus;
  final String? nationalityId;
  final bool? naturalized;
  final bool? isCandidate;
  final bool? isRetired;
  final bool? hasWorkBooklet;
  final bool? ruralWorker;
  final int? declarationType;
  final bool? declared;
  // Documentos
  final bool? personHasCin;
  final String? personRg;
  final String? personRgIssuingAuthority;
  final String? personMobileNumber;
  // Saúde
  final bool? hasChronicDisease;
  final String? chronicDiseaseName;
  final bool? hasHighAbilityGiftedness;
  final bool? hasAutismSpectrumDisorder;
  final String? specialNeedsId;
  // Benefícios
  final bool? hasCadUnico;
  final String? governmentBeneficiaryNis;
  final bool? hasAlimony;
  final double? alimonyAmount;
  final bool? hasInssAssistance;
  final double? inssAssistanceAmount;
  final bool? hasPrivatePension;
  final double? privatePensionAmount;
  final bool? receivePension;
  // Ocupações
  final List<OccupationEntity> occupations;

  const FamilyMemberEntity({
    this.id,
    this.name,
    this.personCpf,
    this.personBirthDate,
    this.personGender,
    required this.kinshipType,
    required this.maritalStatus,
    this.nationalityId,
    this.naturalized,
    this.isCandidate,
    this.isRetired,
    this.hasWorkBooklet,
    this.ruralWorker,
    this.declarationType,
    this.declared,
    this.personHasCin,
    this.personRg,
    this.personRgIssuingAuthority,
    this.personMobileNumber,
    this.hasChronicDisease,
    this.chronicDiseaseName,
    this.hasHighAbilityGiftedness,
    this.hasAutismSpectrumDisorder,
    this.specialNeedsId,
    this.hasCadUnico,
    this.governmentBeneficiaryNis,
    this.hasAlimony,
    this.alimonyAmount,
    this.hasInssAssistance,
    this.inssAssistanceAmount,
    this.hasPrivatePension,
    this.privatePensionAmount,
    this.receivePension,
    this.occupations = const [],
  });

  // Calcula a idade para filtro de ocupações
  int get age {
    if (personBirthDate == null) return 0;
    final now = DateTime.now();
    int age = now.year - personBirthDate!.year;
    if (now.month < personBirthDate!.month ||
        (now.month == personBirthDate!.month &&
            now.day < personBirthDate!.day)) {
      age--;
    }
    return age;
  }

  bool get isResponsible => kinshipType == 1;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'personCpf': personCpf,
        'personBirthDate': personBirthDate?.toIso8601String(),
        'personGender': personGender,
        'kinshipType': kinshipType,
        'maritalStatus': maritalStatus,
        'nationalityId': nationalityId,
        'naturalized': naturalized,
        'isCandidate': isCandidate,
        'isRetired': isRetired,
        'hasWorkBooklet': hasWorkBooklet,
        'ruralWorker': ruralWorker,
        'declarationType': declarationType,
        'declared': declared,
        'personHasCin': personHasCin,
        'personRg': personRg,
        'personRgIssuingAuthority': personRgIssuingAuthority,
        'personMobileNumber': personMobileNumber,
        'hasChronicDisease': hasChronicDisease,
        'chronicDiseaseName': chronicDiseaseName,
        'hasHighAbilityGiftedness': hasHighAbilityGiftedness,
        'hasAutismSpectrumDisorder': hasAutismSpectrumDisorder,
        'specialNeedsId': specialNeedsId,
        'hasCadUnico': hasCadUnico,
        'governmentBeneficiaryNis': governmentBeneficiaryNis,
        'hasAlimony': hasAlimony,
        'alimonyAmount': alimonyAmount,
        'hasInssAssistance': hasInssAssistance,
        'inssAssistanceAmount': inssAssistanceAmount,
        'hasPrivatePension': hasPrivatePension,
        'privatePensionAmount': privatePensionAmount,
        'receivePension': receivePension,
        'occupations': occupations.map((o) => o.toJson()).toList(),
      };

  factory FamilyMemberEntity.fromJson(Map<String, dynamic> json) =>
      FamilyMemberEntity(
        id: json['id'] as String?,
        name: json['name'] as String?,
        personCpf: json['personCpf'] as String?,
        personBirthDate: json['personBirthDate'] != null
            ? DateTime.tryParse(json['personBirthDate'] as String)
            : null,
        personGender: json['personGender'] as int?,
        kinshipType: json['kinshipType'] as int? ?? 1,
        maritalStatus: json['maritalStatus'] as int? ?? 1,
        nationalityId: json['nationalityId'] as String?,
        naturalized: json['naturalized'] as bool?,
        isCandidate: json['isCandidate'] as bool?,
        isRetired: json['isRetired'] as bool?,
        hasWorkBooklet: json['hasWorkBooklet'] as bool?,
        ruralWorker: json['ruralWorker'] as bool?,
        declarationType: json['declarationType'] as int?,
        declared: json['declared'] as bool?,
        personHasCin: json['personHasCin'] as bool?,
        personRg: json['personRg'] as String?,
        personRgIssuingAuthority: json['personRgIssuingAuthority'] as String?,
        personMobileNumber: json['personMobileNumber'] as String?,
        hasChronicDisease: json['hasChronicDisease'] as bool?,
        chronicDiseaseName: json['chronicDiseaseName'] as String?,
        hasHighAbilityGiftedness: json['hasHighAbilityGiftedness'] as bool?,
        hasAutismSpectrumDisorder: json['hasAutismSpectrumDisorder'] as bool?,
        specialNeedsId: json['specialNeedsId'] as String?,
        hasCadUnico: json['hasCadUnico'] as bool?,
        governmentBeneficiaryNis: json['governmentBeneficiaryNis'] as String?,
        hasAlimony: json['hasAlimony'] as bool?,
        alimonyAmount: (json['alimonyAmount'] as num?)?.toDouble(),
        hasInssAssistance: json['hasInssAssistance'] as bool?,
        inssAssistanceAmount:
            (json['inssAssistanceAmount'] as num?)?.toDouble(),
        hasPrivatePension: json['hasPrivatePension'] as bool?,
        privatePensionAmount:
            (json['privatePensionAmount'] as num?)?.toDouble(),
        receivePension: json['receivePension'] as bool?,
        occupations: (json['occupations'] as List?)
                ?.map((e) => OccupationEntity.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );
}
