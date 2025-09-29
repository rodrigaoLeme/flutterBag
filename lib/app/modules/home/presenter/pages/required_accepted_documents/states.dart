// ignore_for_file: public_member_api_docs, sort_constructors_first
class StoreState {
  final String documentId;
  final String scholarshipProofDocumentId;
  final List<AcceptedDocumentFileViewModel> files;
  final String selectedAcceptedDocumentName;

  const StoreState(
      {required this.documentId,
      required this.scholarshipProofDocumentId,
      required this.files,
      required this.selectedAcceptedDocumentName});

  StoreState copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    String? selectedAcceptedDocumentName,
    List<AcceptedDocumentFileViewModel>? files,
  }) {
    return StoreState(
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
    );
  }
}

class Initial extends StoreState {
  const Initial() : super(documentId: '', scholarshipProofDocumentId: '', files: const [], selectedAcceptedDocumentName: '');

  @override
  StoreState copyWith(
      {String? documentId,
      String? scholarshipProofDocumentId,
      List<AcceptedDocumentFileViewModel>? files,
      String? selectedAcceptedDocumentName}) {
    return const Initial();
  }
}

mixin Set on StoreState {}

class NewSet extends StoreState with Set {
  const NewSet(
      {required super.documentId,
      required super.scholarshipProofDocumentId,
      required super.files,
      required super.selectedAcceptedDocumentName});

  @override
  NewSet copyWith(
      {String? documentId,
      String? scholarshipProofDocumentId,
      List<AcceptedDocumentFileViewModel>? files,
      String? selectedAcceptedDocumentName}) {
    return NewSet(
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
    );
  }
}

mixin Adding on StoreState {
  List<String> get photoPaths;

  @override
  Adding copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
  });
}

class NewAdding extends StoreState with Adding {
  @override
  final List<String> photoPaths;

  const NewAdding(
      {required super.documentId,
      required super.scholarshipProofDocumentId,
      required this.photoPaths,
      required super.files,
      required super.selectedAcceptedDocumentName});

  @override
  NewAdding copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
  }) {
    return NewAdding(
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
    );
  }
}

class NewAddingPdf extends StoreState with Adding {
  @override
  final List<String> photoPaths;

  const NewAddingPdf({
    required super.documentId,
    required super.scholarshipProofDocumentId,
    required this.photoPaths,
    required super.files,
    required super.selectedAcceptedDocumentName,
  });

  @override
  NewAddingPdf copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
  }) {
    return NewAddingPdf(
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
    );
  }
}

mixin Editing on StoreState {
  String get editingScholarshipProofDocumentId;
  StoreState get stateBeforeEditing;
}

class ConfirmEditing extends StoreState with Editing {
  @override
  final String editingScholarshipProofDocumentId;
  @override
  final StoreState stateBeforeEditing;

  const ConfirmEditing({
    required this.editingScholarshipProofDocumentId,
    required this.stateBeforeEditing,
    required super.documentId,
    required super.scholarshipProofDocumentId,
    required super.files,
    required super.selectedAcceptedDocumentName,
  });

  @override
  ConfirmEditing copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? editingScholarshipProofDocumentId,
    StoreState? stateBeforeEditing,
    String? selectedAcceptedDocumentName,
  }) {
    return ConfirmEditing(
      editingScholarshipProofDocumentId: editingScholarshipProofDocumentId ?? this.editingScholarshipProofDocumentId,
      stateBeforeEditing: stateBeforeEditing ?? this.stateBeforeEditing,
      files: files ?? this.files,
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
    );
  }
}

class EditingSet extends StoreState with Editing, Set {
  @override
  final String editingScholarshipProofDocumentId;
  @override
  final StoreState stateBeforeEditing;

  const EditingSet({
    required this.editingScholarshipProofDocumentId,
    required this.stateBeforeEditing,
    required super.documentId,
    required super.scholarshipProofDocumentId,
    required super.files,
    required super.selectedAcceptedDocumentName,
  });

  @override
  EditingSet copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? editingScholarshipProofDocumentId,
    StoreState? stateBeforeEditing,
    String? selectedAcceptedDocumentName,
  }) {
    return EditingSet(
      editingScholarshipProofDocumentId: editingScholarshipProofDocumentId ?? this.editingScholarshipProofDocumentId,
      stateBeforeEditing: stateBeforeEditing ?? this.stateBeforeEditing,
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
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

  const EditingAdding({
    required this.editingScholarshipProofDocumentId,
    required this.stateBeforeEditing,
    required super.documentId,
    required super.scholarshipProofDocumentId,
    required this.photoPaths,
    required super.files,
    required super.selectedAcceptedDocumentName,
  });

  @override
  EditingAdding copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
  }) {
    return EditingAdding(
      editingScholarshipProofDocumentId: editingScholarshipProofDocumentId,
      stateBeforeEditing: stateBeforeEditing,
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
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

  const EditingAddingPdf({
    required this.editingScholarshipProofDocumentId,
    required this.stateBeforeEditing,
    required super.documentId,
    required super.scholarshipProofDocumentId,
    required this.photoPaths,
    required super.files,
    required super.selectedAcceptedDocumentName,
  });

  @override
  EditingAddingPdf copyWith({
    String? documentId,
    String? scholarshipProofDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
  }) {
    return EditingAddingPdf(
      editingScholarshipProofDocumentId: editingScholarshipProofDocumentId,
      stateBeforeEditing: stateBeforeEditing,
      documentId: documentId ?? this.documentId,
      scholarshipProofDocumentId: scholarshipProofDocumentId ?? this.scholarshipProofDocumentId,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
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
