class MinimumWageEntity {
  final double? value;
  final int year;
  final DateTime validFrom;

  const MinimumWageEntity({
    this.value,
    required this.year,
    required this.validFrom,
  });

  factory MinimumWageEntity.fromJson(Map<String, dynamic> json) =>
      MinimumWageEntity(
        value: json['value'] as double?,
        year: json['year'] as int,
        validFrom: json['validFrom'] as DateTime,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'year': year,
        'validFrom': validFrom,
      };
}
