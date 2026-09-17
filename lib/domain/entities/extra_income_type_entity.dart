class ExtraIncomeTypeEntity {
  final String id;
  final String? name;
  final String? description;
  final bool hasDescription;
  final bool isAnnualIncome;
  final int order;

  const ExtraIncomeTypeEntity({
    required this.id,
    this.name,
    this.description,
    this.hasDescription = false,
    this.isAnnualIncome = false,
    required this.order,
  });

  factory ExtraIncomeTypeEntity.fromJson(Map<String, dynamic> json) =>
      ExtraIncomeTypeEntity(
        id: json['id'] as String,
        name: json['name'] as String?,
        description: json['description'] as String?,
        hasDescription: json['hasDescription'] as bool? ?? false,
        isAnnualIncome: json['isAnnualIncome'] as bool? ?? false,
        order: int.tryParse(json['order']?.toString() ?? '0') ?? 0,
      );
}
