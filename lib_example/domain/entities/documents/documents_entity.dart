class DocumentsEntity {
  final List<DocumentsResultEntity> documents;

  DocumentsEntity({
    required this.documents,
  });
}

class DocumentsResultEntity {
  final String externalId;
  final String eventExternalId;
  final String sections;
  final String name;
  final String description;
  final String url;
  final int order;

  DocumentsResultEntity({
    required this.externalId,
    required this.eventExternalId,
    required this.sections,
    required this.name,
    required this.description,
    required this.url,
    required this.order,
  });
}
