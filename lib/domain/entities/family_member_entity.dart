import 'extra_income_entity.dart';
import 'occupation_entity.dart';

class FamilyMemberEntity {
  final String id;
  final String? personId;
  final String? name;
  final int? kinshipType;
  final bool? isResponsible;
  final bool? isCandidate;
  final int maritalStatus;
  final int? declarationType;
  final bool? declared;
  final bool? ruralWorker;
  final bool? isRetired;
  final bool? hasWorkBooklet;
  final bool? naturalized;
  final String? personCpf;
  final String? nationalityId;

  final DateTime? personBirthDate;
  final int? personGender;
  // Documentos
  final bool? personHasCin;
  final String? personRg;
  final String? personRgIssuingAuthority;
  final String? personMobileNumber;

  // Saúde
  final bool? hasChronicDisease;
  final String? chronicDiseaseName;
  final String? specialNeedsId;
  final bool? hasAutismSpectrumDisorder;
  final bool? hasHighAbilityGiftedness;
  final String? specialNeedsName;

  // Benefícios
  final bool? hasAlimony;
  final double? alimonyAmount;
  final bool? hasInssAssistance;
  final double? inssAssistanceAmount;
  final bool? hasPrivatePension;
  final double? privatePensionAmount;
  final bool? receivePension;
  final bool? hasCadUnico;
  final String? governmentBeneficiaryNis;

  // Ocupações
  final List<OccupationEntity> occupations;

  final List<ExtraIncomeEntity> extraIncomes;

  const FamilyMemberEntity({
    required this.id,
    this.personId,
    this.name,
    this.kinshipType,
    this.isResponsible,
    this.isCandidate,
    required this.maritalStatus,
    this.declarationType,
    this.declared,
    this.ruralWorker,
    this.hasAlimony,
    this.alimonyAmount,
    this.hasInssAssistance,
    this.inssAssistanceAmount,
    this.hasPrivatePension,
    this.privatePensionAmount,
    this.receivePension,
    this.isRetired,
    this.hasWorkBooklet,
    this.hasCadUnico,
    this.governmentBeneficiaryNis,
    this.hasChronicDisease,
    this.chronicDiseaseName,
    this.specialNeedsId,
    this.hasAutismSpectrumDisorder,
    this.hasHighAbilityGiftedness,
    this.specialNeedsName,
    this.naturalized,
    this.personCpf,
    this.nationalityId,
    this.personBirthDate,
    this.personGender,
    this.personHasCin,
    this.personRg,
    this.personRgIssuingAuthority,
    this.personMobileNumber,
    this.occupations = const [],
    this.extraIncomes = const [],
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'personId': personId,
        'name': name,
        'kinshipType': kinshipType,
        'isResponsible': isResponsible,
        'isCandidate': isCandidate,
        'maritalStatus': maritalStatus,
        'declarationType': declarationType,
        'declared': declared,
        'ruralWorker': ruralWorker,
        'hasAlimony': hasAlimony,
        'alimonyAmount': alimonyAmount,
        'hasInssAssistance': hasInssAssistance,
        'inssAssistanceAmount': inssAssistanceAmount,
        'hasPrivatePension': hasPrivatePension,
        'privatePensionAmount': privatePensionAmount,
        'receivePension': receivePension,
        'isRetired': isRetired,
        'hasWorkBooklet': hasWorkBooklet,
        'hasCadUnico': hasCadUnico,
        'governmentBeneficiaryNis': governmentBeneficiaryNis,
        'hasChronicDisease': hasChronicDisease,
        'chronicDiseaseName': chronicDiseaseName,
        'specialNeedsId': specialNeedsId,
        'hasAutismSpectrumDisorder': hasAutismSpectrumDisorder,
        'hasHighAbilityGiftedness': hasHighAbilityGiftedness,
        'specialNeedsName': specialNeedsName,
        'naturalized': naturalized,
        'personCpf': personCpf,
        'nationalityId': nationalityId,
        'personBirthDate': personBirthDate?.toIso8601String(),
        'personGender': personGender,
        'personHasCin': personHasCin,
        'personRg': personRg,
        'personRgIssuingAuthority': personRgIssuingAuthority,
        'personMobileNumber': personMobileNumber,
        'occupations': occupations.map((o) => o.toJson()).toList(),
        'extraIncomes': extraIncomes.map((e) => e.toJson()).toList(),
      };

  factory FamilyMemberEntity.fromJson(Map<String, dynamic> json) =>
      FamilyMemberEntity(
        id: json['id'] as String,
        personId: json['personId'] as String?,
        name: json['name'] as String?,
        kinshipType: json['kinshipType'] as int? ?? 1,
        isResponsible: json['isResponsible'] as bool?,
        isCandidate: json['isCandidate'] as bool?,
        maritalStatus: json['maritalStatus'] as int? ?? 1,
        declarationType: json['declarationType'] as int?,
        declared: json['declared'] as bool?,
        ruralWorker: json['ruralWorker'] as bool?,
        hasAlimony: json['hasAlimony'] as bool?,
        alimonyAmount: _parseDouble(json['alimonyAmount']),
        hasInssAssistance: json['hasInssAssistance'] as bool?,
        inssAssistanceAmount: _parseDouble(json['inssAssistanceAmount']),
        hasPrivatePension: json['hasPrivatePension'] as bool?,
        privatePensionAmount: _parseDouble(json['privatePensionAmount']),
        receivePension: json['receivePension'] as bool?,
        isRetired: json['isRetired'] as bool?,
        hasWorkBooklet: json['hasWorkBooklet'] as bool?,
        hasCadUnico: json['hasCadUnico'] as bool?,
        governmentBeneficiaryNis: json['governmentBeneficiaryNis'] as String?,
        hasChronicDisease: json['hasChronicDisease'] as bool?,
        chronicDiseaseName: json['chronicDiseaseName'] as String?,
        specialNeedsId: json['specialNeedsId'] as String?,
        hasAutismSpectrumDisorder: json['hasAutismSpectrumDisorder'] as bool?,
        hasHighAbilityGiftedness: json['hasHighAbilityGiftedness'] as bool?,
        specialNeedsName: json['specialNeedsName'] as String?,
        naturalized: json['naturalized'] as bool?,
        personCpf: (json['personCpf'] ?? json['personCPF']) as String?,
        nationalityId: json['nationalityId'] as String?,
        personBirthDate: json['personBirthDate'] != null
            ? DateTime.tryParse(json['personBirthDate'] as String)
            : null,
        personGender: json['personGender'] as int?,
        personHasCin: json['personHasCin'] as bool?,
        personRg: json['personRg'] as String?,
        personRgIssuingAuthority: json['personRgIssuingAuthority'] as String?,
        personMobileNumber: json['personMobileNumber'] as String?,
        occupations: ((json['occupations'] ?? json['ocupations']) as List?)
                ?.map((e) => OccupationEntity.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
        extraIncomes: (json['extraIncomes'] as List?)
                ?.map((e) => ExtraIncomeEntity.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}
