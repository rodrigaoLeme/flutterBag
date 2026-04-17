class BrochuresEntity {
  final List<BrochuresResultEntity> result;

  BrochuresEntity({
    required this.result,
  });
}

class BrochuresResultEntity {
  final String externalId;
  final String eventExternalId;
  final String title;
  final String link;

  BrochuresResultEntity({
    required this.externalId,
    required this.eventExternalId,
    required this.title,
    required this.link,
  });
}
