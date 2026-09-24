import 'enrollment_enums.dart';

class OccupationTypeEntity {
  final String id;
  final String? name;
  final String? description;
  final bool hasIncome;
  final bool hasFunction;
  final bool hasDescription;
  final int order;
  final List<int> occupationRules;

  const OccupationTypeEntity({
    required this.id,
    this.name,
    this.description,
    required this.hasIncome,
    required this.hasFunction,
    required this.hasDescription,
    required this.order,
    this.occupationRules = const [],
  });

  bool isCompatibleWith({required int age, required bool hasPwd}) {
    if (occupationRules.isEmpty) return false;
    final requiredRule = _requiredRuleFor(age: age, hasPwd: hasPwd);
    if (requiredRule == null) return true;
    return occupationRules.contains(requiredRule.value);
  }

  static OccupationRule? _requiredRuleFor(
      {required int age, required bool hasPwd}) {
    if (age <= 13) return OccupationRule.childrenOnly;
    if (age <= 15) return OccupationRule.juniorTeenagerOnly;
    if (age <= 17) return OccupationRule.seniorTeenagerOnly;
    if (age <= 23) return OccupationRule.juniorAdultOnly;
    if (hasPwd) return OccupationRule.seniorAdultPwdOnly;
    return OccupationRule.seniorAdultOnly;
  }

  factory OccupationTypeEntity.fromJson(Map<String, dynamic> json) =>
      OccupationTypeEntity(
        id: json['id'] as String,
        name: json['name'] as String?,
        description: json['description'] as String?,
        hasIncome: json['hasIncome'] as bool? ?? false,
        hasFunction: json['hasFunction'] as bool? ?? false,
        hasDescription: json['hasDescription'] as bool? ?? false,
        order: int.tryParse(json['order']?.toString() ?? '0') ?? 0,
        occupationRules:
            (json['occupationRules'] as List?)?.map((e) => e as int).toList() ??
                [],
      );
}
