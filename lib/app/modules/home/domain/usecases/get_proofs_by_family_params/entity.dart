// ignore_for_file: public_member_api_docs, sort_constructors_first
class Entity {
  final List<Proof> proofs;

  const Entity({required this.proofs});

  factory Entity.empty() => const Entity(proofs: []);
}

class Proof {
  final String id;
  final String scholarshipId;
  final String? entityProofCategorieId;
  final String entityProofConfigId;
  final EntityProofConfig entityProofConfig;
  final List<ScholarshipProofDocument> scholarshipProofDocuments;

  const Proof({
    required this.id,
    required this.scholarshipId,
    required this.entityProofCategorieId,
    required this.entityProofConfigId,
    required this.entityProofConfig,
    required this.scholarshipProofDocuments,
  });

  Proof copyWith({
    String? id,
    String? scholarshipId,
    String? entityProofCategorieId,
    String? entityProofConfigId,
    EntityProofConfig? entityProofConfig,
    List<ScholarshipProofDocument>? scholarshipProofDocuments,
  }) {
    return Proof(
      id: id ?? this.id,
      scholarshipId: scholarshipId ?? this.scholarshipId,
      entityProofCategorieId:
          entityProofCategorieId ?? this.entityProofCategorieId,
      entityProofConfigId: entityProofConfigId ?? this.entityProofConfigId,
      entityProofConfig: entityProofConfig ?? this.entityProofConfig,
      scholarshipProofDocuments:
          scholarshipProofDocuments ?? this.scholarshipProofDocuments,
    );
  }
}

class EntityProofConfig {
  final String id;
  final String yearProofConfigId;
  final String proofId;
  final EntityProof entityProof;
  final String? description;
  final List<ProofItemConfigs> proofItemConfigs;

  const EntityProofConfig({
    required this.id,
    required this.yearProofConfigId,
    required this.proofId,
    required this.entityProof,
    required this.description,
    required this.proofItemConfigs,
  });

  EntityProofConfig copyWith({
    String? id,
    String? yearProofConfigId,
    String? proofId,
    EntityProof? entityProof,
    String? description,
    List<ProofItemConfigs>? proofItemConfigs,
  }) {
    return EntityProofConfig(
      id: id ?? this.id,
      yearProofConfigId: yearProofConfigId ?? this.yearProofConfigId,
      proofId: proofId ?? this.proofId,
      entityProof: entityProof ?? this.entityProof,
      description: description ?? this.description,
      proofItemConfigs: proofItemConfigs ?? this.proofItemConfigs,
    );
  }
}

class EntityProof {
  final String id;
  final String name;
  final String? description;
  final bool active;
  final String proofCategoryId;
  final ProofCategory proofCategory;

  const EntityProof({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.proofCategoryId,
    required this.proofCategory,
  });

  EntityProof copyWith({
    String? id,
    String? name,
    String? description,
    bool? active,
    String? proofCategoryId,
    ProofCategory? proofCategory,
  }) {
    return EntityProof(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
      proofCategoryId: proofCategoryId ?? this.proofCategoryId,
      proofCategory: proofCategory ?? this.proofCategory,
    );
  }
}

class ProofCategory {
  final String id;
  final String name;

  const ProofCategory({
    required this.id,
    required this.name,
  });

  ProofCategory copyWith({
    String? id,
    String? name,
  }) {
    return ProofCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class ProofItemConfigs {
  final String id;
  final String entityProofConfigId;
  final String? description;
  final List<ProofDocumentConfigs> proofDocumentConfigs;

  const ProofItemConfigs({
    required this.id,
    required this.entityProofConfigId,
    required this.description,
    required this.proofDocumentConfigs,
  });

  ProofItemConfigs copyWith({
    String? id,
    String? entityProofConfigId,
    String? description,
    List<ProofDocumentConfigs>? proofDocumentConfigs,
  }) {
    return ProofItemConfigs(
      id: id ?? this.id,
      entityProofConfigId: entityProofConfigId ?? this.entityProofConfigId,
      description: description ?? this.description,
      proofDocumentConfigs: proofDocumentConfigs ?? this.proofDocumentConfigs,
    );
  }
}

class ProofDocumentConfigs {
  final String id;
  final String proofItemConfigId;
  final String documentId;
  final Document document;
  final bool active;

  const ProofDocumentConfigs({
    required this.id,
    required this.proofItemConfigId,
    required this.documentId,
    required this.document,
    required this.active,
  });

  ProofDocumentConfigs copyWith({
    String? id,
    String? proofItemConfigId,
    String? documentId,
    Document? document,
    bool? active,
  }) {
    return ProofDocumentConfigs(
      id: id ?? this.id,
      proofItemConfigId: proofItemConfigId ?? this.proofItemConfigId,
      documentId: documentId ?? this.documentId,
      document: document ?? this.document,
      active: active ?? this.active,
    );
  }
}

class Document {
  final String id;
  final String name;
  final String? nameDescription;
  final String documentCategoryId;
  final String? documentCategory;
  final bool isDeclaration;
  final bool active;

  const Document({
    required this.id,
    required this.name,
    required this.nameDescription,
    required this.documentCategoryId,
    required this.documentCategory,
    required this.isDeclaration,
    required this.active,
  });

  Document copyWith({
    String? id,
    String? name,
    String? nameDescription,
    String? documentCategoryId,
    String? documentCategory,
    bool? isDeclaration,
    bool? active,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      nameDescription: nameDescription ?? this.nameDescription,
      documentCategoryId: documentCategoryId ?? this.documentCategoryId,
      documentCategory: documentCategory ?? this.documentCategory,
      isDeclaration: isDeclaration ?? this.isDeclaration,
      active: active ?? this.active,
    );
  }
}

class ScholarshipProofDocument {
  final String id;
  final String scholarshipProofId;
  final String? entityProofItemId;
  final String proofItemConfigId;
  final ProofItemConfig proofItemConfig;
  final String? documentId;
  final String? fileId;
  final bool documentLocked;

  const ScholarshipProofDocument({
    required this.id,
    required this.scholarshipProofId,
    required this.entityProofItemId,
    required this.proofItemConfigId,
    required this.proofItemConfig,
    required this.documentId,
    required this.fileId,
    required this.documentLocked,
  });

  ScholarshipProofDocument copyWith({
    String? id,
    String? scholarshipProofId,
    String? entityProofItemId,
    String? proofItemConfigId,
    ProofItemConfig? proofItemConfig,
    String? documentId,
    String? fileId,
    bool? documentLocked,
  }) {
    return ScholarshipProofDocument(
      id: id ?? this.id,
      scholarshipProofId: scholarshipProofId ?? this.scholarshipProofId,
      entityProofItemId: entityProofItemId ?? this.entityProofItemId,
      proofItemConfigId: proofItemConfigId ?? this.proofItemConfigId,
      proofItemConfig: proofItemConfig ?? this.proofItemConfig,
      documentId: documentId ?? this.documentId,
      fileId: fileId ?? this.fileId,
      documentLocked: documentLocked ?? this.documentLocked,
    );
  }
}

class ProofItemConfig {
  final String id;
  final String entityProofConfigId;
  final String? description;

  const ProofItemConfig({
    required this.id,
    required this.entityProofConfigId,
    required this.description,
  });

  ProofItemConfig copyWith({
    String? id,
    String? entityProofConfigId,
    String? description,
  }) {
    return ProofItemConfig(
      id: id ?? this.id,
      entityProofConfigId: entityProofConfigId ?? this.entityProofConfigId,
      description: description ?? this.description,
    );
  }
}
