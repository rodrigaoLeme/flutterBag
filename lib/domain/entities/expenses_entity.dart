import 'enrollment_enums.dart';

double? _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

class EducationSpendingEntity {
  final String? id;
  final EducationSpendingType? educationSpendingType;
  final String? educationSpendingOther;
  final String? familyMemberId;
  final String? educationSpendingInstitution;
  final double? educationSpendingAmount;

  const EducationSpendingEntity({
    this.id,
    this.educationSpendingType,
    this.educationSpendingOther,
    this.familyMemberId,
    this.educationSpendingInstitution,
    this.educationSpendingAmount,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'educationSpendingType': educationSpendingType?.value,
      'educationSpendingOther': educationSpendingOther,
      'familyMemberId': familyMemberId,
      'educationSpendingInstitution': educationSpendingInstitution,
      'educationSpendingAmount': educationSpendingAmount,
    };
    json.removeWhere((_, value) => value == null);
    return json;
  }

  factory EducationSpendingEntity.fromJson(Map<String, dynamic> json) =>
      EducationSpendingEntity(
        id: json['id'] as String?,
        educationSpendingType: EducationSpendingType.fromValue(
          json['educationSpendingType'] as int?,
        ),
        educationSpendingOther: json['educationSpendingOther'] as String?,
        familyMemberId: json['familyMemberId'] as String?,
        educationSpendingInstitution:
            json['educationSpendingInstitution'] as String?,
        educationSpendingAmount: _toDouble(json['educationSpendingAmount']),
      );
}

class ExpensesEntity {
  final double? familyResidenceRentalAmount;
  final double? iptuAmount;
  final double? condominiumAmount;
  final double? gasAmount;
  final double? energyAmount;
  final double? waterAmount;
  final double? phoneAmount;
  final double? otherResidenceAmount;
  final String? otherResidenceDescription;
  final double? foodAmount;
  final double? healthPlanAmount;
  final double? medicalAmount;
  final double? dentalPlanAmount;
  final double? dentalAmount;
  final double? otherHealthAmount;
  final String? otherHealthDescription;
  final double? chronicDiseaseAmount;
  final bool? hasEducationSpending;
  final List<EducationSpendingEntity> educationSpendings;
  final SchoolTransportType? schoolTransportType;
  final double? schoolTransportAmount;
  final double? ipvaAmount;
  final double? carInsuranceAmount;
  final double? bankDebtsAmount;
  final double? otherBankDebtsAmount;
  final String? otherBankDebtsDescription;

  const ExpensesEntity({
    this.familyResidenceRentalAmount,
    this.iptuAmount,
    this.condominiumAmount,
    this.gasAmount,
    this.energyAmount,
    this.waterAmount,
    this.phoneAmount,
    this.otherResidenceAmount,
    this.otherResidenceDescription,
    this.foodAmount,
    this.healthPlanAmount,
    this.medicalAmount,
    this.dentalPlanAmount,
    this.dentalAmount,
    this.otherHealthAmount,
    this.otherHealthDescription,
    this.chronicDiseaseAmount,
    this.hasEducationSpending,
    this.educationSpendings = const [],
    this.schoolTransportType,
    this.schoolTransportAmount,
    this.ipvaAmount,
    this.carInsuranceAmount,
    this.bankDebtsAmount,
    this.otherBankDebtsAmount,
    this.otherBankDebtsDescription,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'familyResidenceRentalAmount': familyResidenceRentalAmount,
      'iptuAmount': iptuAmount,
      'condominiumAmount': condominiumAmount,
      'gasAmount': gasAmount,
      'energyAmount': energyAmount,
      'waterAmount': waterAmount,
      'phoneAmount': phoneAmount,
      'otherResidenceAmount': otherResidenceAmount,
      'otherResidenceDescription': otherResidenceDescription,
      'foodAmount': foodAmount,
      'healthPlanAmount': healthPlanAmount,
      'medicalAmount': medicalAmount,
      'dentalPlanAmount': dentalPlanAmount,
      'dentalAmount': dentalAmount,
      'otherHealthAmount': otherHealthAmount,
      'otherHealthDescription': otherHealthDescription,
      'chronicDiseaseAmount': chronicDiseaseAmount,
      'hasEducationSpending': hasEducationSpending,
      'educationSpendings': educationSpendings.map((e) => e.toJson()).toList(),
      'schoolTransportType': schoolTransportType?.value,
      'schoolTransportAmount': schoolTransportAmount,
      'ipvaAmount': ipvaAmount,
      'carInsuranceAmount': carInsuranceAmount,
      'bankDebtsAmount': bankDebtsAmount,
      'otherBankDebtsAmount': otherBankDebtsAmount,
      'otherBankDebtsDescription': otherBankDebtsDescription,
    };
    // A API rejeita null em alguns decimais (ex.: medicalAmount) com 400.
    // Mantém schoolTransportAmount: null para Não Utiliza / Público (contrato da API).
    json.removeWhere((key, value) {
      if (value != null) return false;
      if (key == 'schoolTransportAmount' &&
          schoolTransportType != null &&
          !schoolTransportType!.requiresAmount) {
        return false;
      }
      return true;
    });
    return json;
  }

  factory ExpensesEntity.fromJson(Map<String, dynamic> json) => ExpensesEntity(
        familyResidenceRentalAmount:
            _toDouble(json['familyResidenceRentalAmount']),
        iptuAmount: _toDouble(json['iptuAmount']),
        condominiumAmount: _toDouble(json['condominiumAmount']),
        gasAmount: _toDouble(json['gasAmount']),
        energyAmount: _toDouble(json['energyAmount']),
        waterAmount: _toDouble(json['waterAmount']),
        phoneAmount: _toDouble(json['phoneAmount']),
        otherResidenceAmount: _toDouble(json['otherResidenceAmount']),
        otherResidenceDescription: json['otherResidenceDescription'] as String?,
        foodAmount: _toDouble(json['foodAmount']),
        healthPlanAmount: _toDouble(json['healthPlanAmount']),
        medicalAmount: _toDouble(json['medicalAmount']),
        dentalPlanAmount: _toDouble(json['dentalPlanAmount']),
        dentalAmount: _toDouble(json['dentalAmount']),
        otherHealthAmount: _toDouble(json['otherHealthAmount']),
        otherHealthDescription: json['otherHealthDescription'] as String?,
        chronicDiseaseAmount: _toDouble(json['chronicDiseaseAmount']),
        hasEducationSpending: json['hasEducationSpending'] as bool?,
        educationSpendings: (json['educationSpendings'] as List?)
                ?.map((e) => EducationSpendingEntity.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
        schoolTransportType: SchoolTransportType.fromValue(
          json['schoolTransportType'] as int?,
        ),
        schoolTransportAmount: _toDouble(json['schoolTransportAmount']),
        ipvaAmount: _toDouble(json['ipvaAmount']),
        carInsuranceAmount: _toDouble(json['carInsuranceAmount']),
        bankDebtsAmount: _toDouble(json['bankDebtsAmount']),
        otherBankDebtsAmount: _toDouble(json['otherBankDebtsAmount']),
        otherBankDebtsDescription: json['otherBankDebtsDescription'] as String?,
      );
}
