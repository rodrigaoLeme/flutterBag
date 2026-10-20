class MinimumWageEntity {
  final double? value;
  final int year;
  final DateTime validFrom;

  const MinimumWageEntity({
    this.value,
    required this.year,
    required this.validFrom,
  });

  factory MinimumWageEntity.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MinimumWageEntity(year: 0, validFrom: DateTime(0));
    return MinimumWageEntity(
      value: (json['value'] as num?)?.toDouble(),
      year: int.tryParse(json['year']?.toString() ?? '0') ?? 0,
      validFrom: json['validFrom'] != null
          ? DateTime.tryParse(json['validFrom'] as String) ?? DateTime(0)
          : DateTime(0),
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'year': year,
        'validFrom': validFrom.toIso8601String(),
      };
}
