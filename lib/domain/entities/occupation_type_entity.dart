class OccupationTypeEntity {
  final String id;
  final String? name;
  final String? description;
  final bool hasIncome;
  final bool hasFunction;
  final bool hasDescription;
  final int order;
  final List<int> ocupationRules;

  const OccupationTypeEntity({
    required this.id,
    this.name,
    this.description,
    required this.hasIncome,
    required this.hasFunction,
    required this.hasDescription,
    required this.order,
    this.ocupationRules = const [],
  });

  factory OccupationTypeEntity.fromJson(Map<String, dynamic> json) =>
      OccupationTypeEntity(
        id: json['id'] as String,
        name: json['name'] as String?,
        description: json['description'] as String?,
        hasIncome: json['hasIncome'] as bool? ?? false,
        hasFunction: json['hasFunction'] as bool? ?? false,
        hasDescription: json['hasDescription'] as bool? ?? false,
        order: int.tryParse(json['order']?.toString() ?? '0') ?? 0,
        ocupationRules:
            (json['ocupationRules'] as List?)?.map((e) => e as int).toList() ??
                [],
      );
}
