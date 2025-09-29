// ignore_for_file: public_member_api_docs, sort_constructors_first
class StoreState {
  final String documentId;
  final String scholarshipProofDocumentId;
  final List<AcceptedDocumentFileViewModel> files;
  final String selectedAcceptedDocumentName;
  final String scholarshipReviewId;

  const StoreState({
    required this.documentId,
    required this.scholarshipProofDocumentId,
    required this.files,
    required this.selectedAcceptedDocumentName,
    required this.scholarshipReviewId,
  });

  StoreState copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    String? selectedAcceptedDocumentName,
    List<AcceptedDocumentFileViewModel>? files,
    String? scholarshipReviewId,
  }) {
    return StoreState(
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
    );
  }
}

class Initial extends StoreState {
  const Initial({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipReviewId,
  }) : super(
          documentId: documentId ?? '',
          scholarshipProofDocumentId: scholarshipProofDocumentId ?? '',
          files: files ?? const [],
          selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? '',
          scholarshipReviewId: scholarshipReviewId ?? '',
        );

  @override
  StoreState copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipReviewId,
  }) {
    return Initial(
      documentId: documentId,
      files: files,
      scholarshipProofDocumentId: scholarshipProofDocumentId,
      scholarshipReviewId: scholarshipReviewId,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName,
    );
  }
}

mixin Set on StoreState {}

mixin Adding on StoreState {
  List<String> get photoPaths;

  @override
  Adding copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipReviewId,
  });
}

mixin Editing on StoreState {
  String get editingScholarshipProofDocumentId;
  StoreState get stateBeforeEditing;
  String get originalAcceptedDocumentId;
}

class ConfirmEditing extends StoreState with Editing {
  @override
  final String editingScholarshipProofDocumentId;
  @override
  final StoreState stateBeforeEditing;
  @override
  final String originalAcceptedDocumentId;

  const ConfirmEditing({
    required this.editingScholarshipProofDocumentId,
    required this.stateBeforeEditing,
    required super.documentId,
    required super.scholarshipProofDocumentId,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required this.originalAcceptedDocumentId,
    required super.scholarshipReviewId,
  });

  @override
  ConfirmEditing copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? editingScholarshipProofDocumentId,
    StoreState? stateBeforeEditing,
    String? selectedAcceptedDocumentName,
    String? originalAcceptedDocumentId,
    String? scholarshipReviewId,
  }) {
    return ConfirmEditing(
      editingScholarshipProofDocumentId: editingScholarshipProofDocumentId ?? this.editingScholarshipProofDocumentId,
      stateBeforeEditing: stateBeforeEditing ?? this.stateBeforeEditing,
      files: files ?? this.files,
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      originalAcceptedDocumentId: originalAcceptedDocumentId ?? this.originalAcceptedDocumentId,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
    );
  }
}

class EditingSet extends StoreState with Editing, Set {
  @override
  final String editingScholarshipProofDocumentId;
  @override
  final StoreState stateBeforeEditing;
  @override
  final String originalAcceptedDocumentId;

  const EditingSet({
    required this.editingScholarshipProofDocumentId,
    required this.stateBeforeEditing,
    required super.documentId,
    required super.scholarshipProofDocumentId,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required this.originalAcceptedDocumentId,
    required super.scholarshipReviewId,
  });

  @override
  EditingSet copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? editingScholarshipProofDocumentId,
    StoreState? stateBeforeEditing,
    String? selectedAcceptedDocumentName,
    String? originalAcceptedDocumentId,
    String? scholarshipReviewId,
  }) {
    return EditingSet(
      editingScholarshipProofDocumentId: editingScholarshipProofDocumentId ?? this.editingScholarshipProofDocumentId,
      stateBeforeEditing: stateBeforeEditing ?? this.stateBeforeEditing,
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      originalAcceptedDocumentId: originalAcceptedDocumentId ?? this.originalAcceptedDocumentId,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
    );
  }
}

class EditingAdding extends StoreState with Editing, Adding {
  @override
  final String editingScholarshipProofDocumentId;
  @override
  final StoreState stateBeforeEditing;
  @override
  final List<String> photoPaths;
  @override
  final String originalAcceptedDocumentId;

  const EditingAdding({
    required this.editingScholarshipProofDocumentId,
    required this.stateBeforeEditing,
    required super.documentId,
    required super.scholarshipProofDocumentId,
    required this.photoPaths,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required this.originalAcceptedDocumentId,
    required super.scholarshipReviewId,
  });

  @override
  EditingAdding copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? originalAcceptedDocumentId,
    String? scholarshipReviewId,
  }) {
    return EditingAdding(
      editingScholarshipProofDocumentId: editingScholarshipProofDocumentId,
      stateBeforeEditing: stateBeforeEditing,
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      originalAcceptedDocumentId: originalAcceptedDocumentId ?? this.originalAcceptedDocumentId,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
    );
  }
}

class EditingAddingPdf extends StoreState with Adding, Editing {
  @override
  final String editingScholarshipProofDocumentId;
  @override
  final StoreState stateBeforeEditing;
  @override
  final List<String> photoPaths;
  @override
  final String originalAcceptedDocumentId;

  const EditingAddingPdf({
    required this.editingScholarshipProofDocumentId,
    required this.stateBeforeEditing,
    required super.documentId,
    required super.scholarshipProofDocumentId,
    required this.photoPaths,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required this.originalAcceptedDocumentId,
    required super.scholarshipReviewId,
  });

  @override
  EditingAddingPdf copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? originalAcceptedDocumentId,
    String? scholarshipReviewId,
  }) {
    return EditingAddingPdf(
      editingScholarshipProofDocumentId: editingScholarshipProofDocumentId,
      stateBeforeEditing: stateBeforeEditing,
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      originalAcceptedDocumentId: originalAcceptedDocumentId ?? this.originalAcceptedDocumentId,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
    );
  }
}

class AcceptedDocumentFileViewModel {
  final String fileId;
  final String fileUrl;
  final String fileName;

  const AcceptedDocumentFileViewModel({
    required this.fileId,
    required this.fileUrl,
    required this.fileName,
  });
}
