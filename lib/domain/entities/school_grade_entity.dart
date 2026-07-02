class SchoolGradeEntity {
  final String id;
  final String? name;

  const SchoolGradeEntity({
    required this.id,
    this.name,
  });

  String get displayName => name ?? id;
}
