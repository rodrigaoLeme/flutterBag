class SectionResultEntity {
  final List<SectionEntity>? sections;

  SectionResultEntity({
    required this.sections,
  });
}

class SectionEntity {
  final String? slug;
  final String? name;
  final String? description;

  SectionEntity({
    required this.slug,
    required this.name,
    required this.description,
  });
}
