import 'enrollment_enums.dart';

class HousingEntity {
  final String processPeriodId;
  final String zipCode;
  final String? street;
  final String? number;
  final String? complement;
  final String? district;
  final String? city;
  final String? state;
  final ResidenceAreaType? residenceAreaType;
  final ResidenceType? residenceType;

  const HousingEntity({
    required this.processPeriodId,
    required this.zipCode,
    this.street,
    this.number,
    this.complement,
    this.district,
    this.city,
    this.state,
    this.residenceAreaType,
    this.residenceType,
  });

  Map<String, dynamic> toJson() => {
        'processPeridoId': processPeriodId,
        'zipCode': zipCode.replaceAll(RegExp(r'\D'), ''),
        'street': street,
        'number': number,
        'complement': complement,
        'district': district,
        'city': city,
        'state': state,
        'residenceAreaType': residenceAreaType?.value,
        'residenceType': residenceType?.value,
      };

  factory HousingEntity.fromJson(Map<String, dynamic> json) => HousingEntity(
        processPeriodId: json['processPeriodId'] as String,
        zipCode: json['zipCode'] as String? ?? '',
        street: json['street'] as String?,
        number: json['number'] as String?,
        complement: json['complement'] as String?,
        district: json['district'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        residenceAreaType:
            ResidenceAreaType.fromValue(json['residenceAreaType'] as int?),
        residenceType: ResidenceType.fromValue(json['residenceType'] as int?),
      );

  bool get isValid =>
      zipCode.replaceAll(RegExp(r'\D'), '').length == 8 &&
      residenceAreaType != null &&
      residenceType != null;
}
