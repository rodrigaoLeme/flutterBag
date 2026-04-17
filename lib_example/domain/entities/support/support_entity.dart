class SupportEntity {
  final List<SupportResultEntity>? support;

  SupportEntity({
    required this.support,
  });
}

class SupportResultEntity {
  final String? externalId;
  final String? eventExternalId;
  final String? title;
  final String? description;

  SupportResultEntity({
    required this.externalId,
    required this.eventExternalId,
    required this.title,
    required this.description,
  });
}
