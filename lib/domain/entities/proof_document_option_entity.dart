class ProofDocumentOptionEntity {
  final String documentId;
  final String? name;
  final String? description;
  final bool isDeclaration;
  final String? declarationTemplateId;

  const ProofDocumentOptionEntity({
    required this.documentId,
    this.name,
    this.description,
    required this.isDeclaration,
    this.declarationTemplateId,
  });

  factory ProofDocumentOptionEntity.fromJson(Map<String, dynamic> json) =>
      ProofDocumentOptionEntity(
        documentId: json['documentId'] as String,
        name: json['name'] as String?,
        description: json['description'] as String?,
        isDeclaration: json['isDeclaration'] as bool? ?? false,
        declarationTemplateId: json['declarationTemplateId'] as String?,
      );
}
