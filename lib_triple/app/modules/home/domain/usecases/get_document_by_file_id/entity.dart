class Entity {
  final AcceptedDocumentFile acceptedDocumentFile;

  const Entity({required this.acceptedDocumentFile});

  factory Entity.empty() => const Entity(acceptedDocumentFile: AcceptedDocumentFile(url: '', name: ''));
}

class AcceptedDocumentFile {
  final String url;
  final String name;

  const AcceptedDocumentFile({
    required this.url,
    required this.name,
  });
}
