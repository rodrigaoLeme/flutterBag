class Entity {
  final List<AcceptedDocument> acceptedDocuments;

  const Entity({required this.acceptedDocuments});

  factory Entity.empty() => const Entity(acceptedDocuments: []);
}

class AcceptedDocument {
  final String id;
  final String name;
  final bool isDeclaration;
  final String proofItemConfigId;

  const AcceptedDocument(
      {required this.id,
      required this.name,
      required this.isDeclaration,
      required this.proofItemConfigId});

  factory AcceptedDocument.empty() => const AcceptedDocument(
        id: '',
        name: '',
        isDeclaration: false,
        proofItemConfigId: '',
      );
}
