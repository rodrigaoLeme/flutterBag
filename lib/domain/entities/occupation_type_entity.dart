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

  bool get isApprentice => _normalizedName.contains('aprendiz');

  bool get isAllowedBetween14And15 => _matchesYoungerTeenOccupation;

  bool get isAllowedBetween16And17 =>
      _matchesYoungerTeenOccupation || _normalizedName.contains('estagi');

  bool get _matchesYoungerTeenOccupation {
    final label = _normalizedName;
    if (label.isEmpty) return false;
    if (label.contains('aprendiz')) return true;
    if (label.contains('estudante')) return true;
    if (label.contains('prestacao continuada') || label.contains('bpc')) {
      return true;
    }
    return label.contains('proprietario') ||
        (label.contains('socio') && label.contains('empresa'));
  }

  String get _normalizedName {
    var value = (name ?? '').toLowerCase();
    const from = 'áàâãäéèêëíìîïóòôõöúùûüç';
    const to = 'aaaaaeeeeiiiiooooouuuuc';
    for (var i = 0; i < from.length; i++) {
      value = value.replaceAll(from[i], to[i]);
    }
    return value.replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
  }

  bool isCompatibleWith({
    required int age,
    required bool hasSpecialCondition,
  }) {
    if (occupationRules.isEmpty) return false;
    final requiredRule = _requiredRuleFor(
      age: age,
      hasSpecialCondition: hasSpecialCondition,
    );
    if (requiredRule == null) return true;
    return occupationRules.contains(requiredRule.value);
  }

  static OccupationRule? _requiredRuleFor({
    required int age,
    required bool hasSpecialCondition,
  }) {
    if (age <= 13) return OccupationRule.childrenOnly;
    if (age <= 15) return OccupationRule.juniorTeenagerOnly;
    if (age <= 17) return OccupationRule.seniorTeenagerOnly;
    if (age <= 23) return OccupationRule.juniorAdultOnly;
    if (hasSpecialCondition) return OccupationRule.seniorAdultPwdOnly;
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
