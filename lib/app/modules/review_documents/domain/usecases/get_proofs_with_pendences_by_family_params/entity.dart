// ignore_for_file: public_member_api_docs, sort_constructors_first
class Entity {
  final List<ProofWithPendences> proofs;

  const Entity({required this.proofs});

  factory Entity.empty() => const Entity(proofs: []);
}

class ProofWithPendences {
  final String id;
  final String scholarshipId;
  final String entityProofConfigId;
  final EntityProofConfigWithPendences entityProofConfig;
  final List<ScholarshipProofDocumentWithPendences> scholarshipProofDocuments;

  const ProofWithPendences({
    required this.id,
    required this.scholarshipId,
    required this.entityProofConfig,
    required this.entityProofConfigId,
    required this.scholarshipProofDocuments,
  });

  ProofWithPendences copyWith({
    String? id,
    String? scholarshipId,
    String? entityProofConfigId,
    EntityProofConfigWithPendences? entityProofConfig,
    List<ScholarshipProofDocumentWithPendences>? scholarshipProofDocuments,
  }) {
    return ProofWithPendences(
      id: id ?? this.id,
      scholarshipId: scholarshipId ?? this.scholarshipId,
      entityProofConfigId: entityProofConfigId ?? this.entityProofConfigId,
      entityProofConfig: entityProofConfig ?? this.entityProofConfig,
      scholarshipProofDocuments:
          scholarshipProofDocuments ?? this.scholarshipProofDocuments,
    );
  }
}

class EntityProofConfigWithPendences {
  final String id;
  final String yearProofConfigId;
  final String proofId;
  final EntityProofWithPendences entityProof;
  final String? description;
  final List<ProofItemConfigsWithPendences> proofItemConfigs;

  const EntityProofConfigWithPendences({
    required this.id,
    required this.yearProofConfigId,
    required this.proofId,
    required this.entityProof,
    required this.description,
    required this.proofItemConfigs,
  });

  EntityProofConfigWithPendences copyWith({
    String? id,
    String? yearProofConfigId,
    String? proofId,
    EntityProofWithPendences? entityProof,
    String? description,
    List<ProofItemConfigsWithPendences>? proofItemConfigs,
  }) {
    return EntityProofConfigWithPendences(
      id: id ?? this.id,
      yearProofConfigId: yearProofConfigId ?? this.yearProofConfigId,
      proofId: proofId ?? this.proofId,
      entityProof: entityProof ?? this.entityProof,
      description: description ?? this.description,
      proofItemConfigs: proofItemConfigs ?? this.proofItemConfigs,
    );
  }
}

class EntityProofWithPendences {
  final String id;
  final String name;
  final String? description;
  final bool active;
  final String proofCategoryId;
  final ProofCategoryWithPendences proofCategory;

  const EntityProofWithPendences({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.proofCategoryId,
    required this.proofCategory,
  });

  EntityProofWithPendences copyWith({
    String? id,
    String? name,
    String? description,
    bool? active,
    String? proofCategoryId,
    ProofCategoryWithPendences? proofCategory,
  }) {
    return EntityProofWithPendences(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
      proofCategoryId: proofCategoryId ?? this.proofCategoryId,
      proofCategory: proofCategory ?? this.proofCategory,
    );
  }
}

class ProofCategoryWithPendences {
  final String id;
  final String name;

  const ProofCategoryWithPendences({
    required this.id,
    required this.name,
  });

  ProofCategoryWithPendences copyWith({
    String? id,
    String? name,
  }) {
    return ProofCategoryWithPendences(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class ProofItemConfigsWithPendences {
  final String id;
  final String entityProofConfigId;
  final String? description;
  final List<ProofDocumentConfigsWithPendences> proofDocumentConfigs;

  const ProofItemConfigsWithPendences({
    required this.id,
    required this.entityProofConfigId,
    required this.description,
    required this.proofDocumentConfigs,
  });

  ProofItemConfigsWithPendences copyWith({
    String? id,
    String? entityProofConfigId,
    String? description,
    List<ProofDocumentConfigsWithPendences>? proofDocumentConfigs,
  }) {
    return ProofItemConfigsWithPendences(
      id: id ?? this.id,
      entityProofConfigId: entityProofConfigId ?? this.entityProofConfigId,
      description: description ?? this.description,
      proofDocumentConfigs: proofDocumentConfigs ?? this.proofDocumentConfigs,
    );
  }
}

class ProofDocumentConfigsWithPendences {
  final String id;
  final String proofItemConfigId;
  final String documentId;
  final DocumentWithPendences document;
  final bool active;

  const ProofDocumentConfigsWithPendences({
    required this.id,
    required this.proofItemConfigId,
    required this.documentId,
    required this.document,
    required this.active,
  });

  ProofDocumentConfigsWithPendences copyWith({
    String? id,
    String? proofItemConfigId,
    String? documentId,
    DocumentWithPendences? document,
    bool? active,
  }) {
    return ProofDocumentConfigsWithPendences(
      id: id ?? this.id,
      proofItemConfigId: proofItemConfigId ?? this.proofItemConfigId,
      documentId: documentId ?? this.documentId,
      document: document ?? this.document,
      active: active ?? this.active,
    );
  }
}

class DocumentWithPendences {
  final String id;
  final String name;
  final String? nameDescription;
  final String documentCategoryId;
  final String? documentCategory;
  final bool isDeclaration;
  final bool active;

  const DocumentWithPendences({
    required this.id,
    required this.name,
    required this.nameDescription,
    required this.documentCategoryId,
    required this.documentCategory,
    required this.isDeclaration,
    required this.active,
  });

  DocumentWithPendences copyWith({
    String? id,
    String? name,
    String? nameDescription,
    String? documentCategoryId,
    String? documentCategory,
    bool? isDeclaration,
    bool? active,
  }) {
    return DocumentWithPendences(
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

class ScholarshipProofDocumentWithPendences {
  final String id;
  final String scholarshipProofId;
  final String? entityProofItemId;
  final String proofItemConfigId;
  final String? documentId;
  final String? fileId;
  final bool documentLocked;
  //final ProofItemConfigWithPendences? proofItemConfigWithPendences;
  final List<ScholarshipProofDocumentReviews> scholarshipProofDocumentReviews;

  const ScholarshipProofDocumentWithPendences({
    required this.id,
    required this.scholarshipProofId,
    required this.entityProofItemId,
    required this.proofItemConfigId,
    required this.documentId,
    required this.fileId,
    required this.documentLocked,
    //required this.proofItemConfigWithPendences,
    required this.scholarshipProofDocumentReviews,
  });

  ScholarshipProofDocumentWithPendences copyWith({
    String? id,
    String? scholarshipProofId,
    String? entityProofItemId,
    String? proofItemConfigId,
    String? documentId,
    String? fileId,
    bool? documentLocked,
    //ProofItemConfigWithPendences? proofItemConfigWithPendences,
    List<ScholarshipProofDocumentReviews>? scholarshipProofDocumentReviews,
  }) {
    return ScholarshipProofDocumentWithPendences(
      id: id ?? this.id,
      scholarshipProofId: scholarshipProofId ?? this.scholarshipProofId,
      entityProofItemId: entityProofItemId ?? this.entityProofItemId,
      proofItemConfigId: proofItemConfigId ?? this.proofItemConfigId,
      documentId: documentId ?? this.documentId,
      fileId: fileId ?? this.fileId,
      documentLocked: documentLocked ?? this.documentLocked,
      //proofItemConfigWithPendences: proofItemConfigWithPendences ?? this.proofItemConfigWithPendences,
      scholarshipProofDocumentReviews: scholarshipProofDocumentReviews ??
          this.scholarshipProofDocumentReviews,
    );
  }
}

class ProofItemConfigWithPendences {
  final String id;
  final String entityProofConfigId;
  final String? description;

  const ProofItemConfigWithPendences({
    required this.id,
    required this.entityProofConfigId,
    required this.description,
  });

  ProofItemConfigWithPendences copyWith({
    String? id,
    String? entityProofConfigId,
    String? description,
  }) {
    return ProofItemConfigWithPendences(
      id: id ?? this.id,
      entityProofConfigId: entityProofConfigId ?? this.entityProofConfigId,
      description: description ?? this.description,
    );
  }
}

class ScholarshipProofDocumentReviews {
  final String id;
  final String scholarshipProofDocumentId;
  final String scholarshipReviewId;
  final String? observation;
  final bool resend;
  final bool newRequirement;

  const ScholarshipProofDocumentReviews({
    required this.id,
    required this.scholarshipProofDocumentId,
    required this.scholarshipReviewId,
    required this.observation,
    required this.resend,
    required this.newRequirement,
  });

  ScholarshipProofDocumentReviews copyWith(
      {String? id,
      String? scholarshipProofDocumentId,
      String? scholarshipReviewId,
      String? observation,
      bool? resend,
      bool? newRequirement}) {
    return ScholarshipProofDocumentReviews(
      id: id ?? this.id,
      scholarshipProofDocumentId:
          scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
      observation: observation ?? this.observation,
      resend: resend ?? this.resend,
      newRequirement: newRequirement ?? this.newRequirement,
    );
  }
}
