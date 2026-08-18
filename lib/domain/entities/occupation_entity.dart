class OccupationEntity {
  final String? id;
  final String? familyMemberId;
  final String occupationTypeId;
  final double? monthlyIncome;
  final String? companyName;
  final int? companyType;
  final String? cnpj;
  final String? function;
  final int? situation;
  final bool? hadActivityLastYear;
  final bool? simplesNacionalTax;
  final bool? unemploymentInsurance;

  const OccupationEntity({
    this.id,
    this.familyMemberId,
    required this.occupationTypeId,
    this.monthlyIncome,
    this.companyName,
    this.companyType,
    this.cnpj,
    this.function,
    this.situation,
    this.hadActivityLastYear,
    this.simplesNacionalTax,
    this.unemploymentInsurance,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'familyMemberId': familyMemberId,
        'occupationTypeId': occupationTypeId,
        'monthlyIncome': monthlyIncome,
        'companyName': companyName,
        'companyType': companyType,
        'cnpj': cnpj,
        'function': function,
        'situation': situation,
        'hadActivityLastYear': hadActivityLastYear,
        'simplesNacionalTax': simplesNacionalTax,
        'unemploymentInsurance': unemploymentInsurance,
      };

  factory OccupationEntity.fromJson(Map<String, dynamic> json) =>
      OccupationEntity(
        id: json['id'] as String?,
        familyMemberId: json['familyMemberId'] as String?,
        occupationTypeId: json['occupationTypeId'] as String? ?? '',
        monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble(),
        companyName: json['companyName'] as String?,
        companyType: json['companyType'] as int?,
        cnpj: json['cnpj'] as String?,
        function: json['function'] as String?,
        situation: json['situation'] as int?,
        hadActivityLastYear: json['hadActivityLastYear'] as bool?,
        simplesNacionalTax: json['simplesNacionalTax'] as bool?,
        unemploymentInsurance: json['unemploymentInsurance'] as bool?,
      );
}
