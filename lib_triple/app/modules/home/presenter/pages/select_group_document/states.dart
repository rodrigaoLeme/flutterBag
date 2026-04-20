// ignore_for_file: public_member_api_docs, sort_constructors_first

abstract class StoreState {
  final String selectedProofId;
  final String selectedScholarshipProofDocumentId;
  final String selectedAcceptedDocumentId;
  final List<AcceptedDocumentFileViewModel> files;
  final String selectedAcceptedDocumentName;
  final String scholarshipProofId;

  const StoreState({
    required this.selectedProofId,
    required this.selectedScholarshipProofDocumentId,
    required this.selectedAcceptedDocumentId,
    required this.files,
    required this.selectedAcceptedDocumentName,
    required this.scholarshipProofId,
  });

  StoreState copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipProofId,
  });
}

class Initial extends StoreState {
  const Initial()
      : super(
          selectedAcceptedDocumentId: '',
          selectedScholarshipProofDocumentId: '',
          selectedProofId: '',
          files: const [],
          selectedAcceptedDocumentName: '',
          scholarshipProofId: '',
        );

  @override
  Initial copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipProofId,
  }) {
    return const Initial();
  }
}

mixin Set on StoreState {}

class NewSet extends StoreState with Set {
  const NewSet({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required super.scholarshipProofId,
  });

  @override
  NewSet copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipProofId,
  }) {
    return NewSet(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ??
          this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId:
          selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      files: files ?? this.files,
      selectedAcceptedDocumentName:
          selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipProofId: scholarshipProofId ?? this.scholarshipProofId,
    );
  }
}

mixin Adding on StoreState {
  List<String> get photoPaths;

  @override
  Adding copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipProofId,
  });
}

class NewAdding extends StoreState with Adding {
  @override
  final List<String> photoPaths;

  const NewAdding({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required this.photoPaths,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required super.scholarshipProofId,
  });

  @override
  NewAdding copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipProofId,
  }) {
    return NewAdding(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ??
          this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId:
          selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName:
          selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipProofId: scholarshipProofId ?? this.scholarshipProofId,
    );
  }
}

class NewAddingPdf extends StoreState with Adding {
  @override
  final List<String> photoPaths;

  const NewAddingPdf({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required this.photoPaths,
    required super.scholarshipProofId,
  });

  @override
  NewAddingPdf copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<String>? photoPaths,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipProofId,
  }) {
    return NewAddingPdf(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ??
          this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId:
          selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName:
          selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipProofId: scholarshipProofId ?? this.scholarshipProofId,
    );
  }
}

mixin Editing on StoreState {
  String get editingProofId;
  StoreState get stateBeforeEditing;
}

class ConfirmEditing extends StoreState with Editing {
  @override
  final String editingProofId;
  @override
  final StoreState stateBeforeEditing;

  const ConfirmEditing({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required this.editingProofId,
    required this.stateBeforeEditing,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required super.scholarshipProofId,
  });

  @override
  ConfirmEditing copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipProofId,
  }) {
    return ConfirmEditing(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ??
          this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId:
          selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      editingProofId: editingProofId,
      stateBeforeEditing: stateBeforeEditing,
      files: files ?? this.files,
      selectedAcceptedDocumentName:
          selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipProofId: scholarshipProofId ?? this.scholarshipProofId,
    );
  }
}

class EditingSet extends StoreState with Set, Editing {
  @override
  final String editingProofId;
  @override
  final StoreState stateBeforeEditing;

  const EditingSet({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required this.editingProofId,
    required this.stateBeforeEditing,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required super.scholarshipProofId,
  });

  @override
  EditingSet copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipProofId,
  }) {
    return EditingSet(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ??
          this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId:
          selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      editingProofId: editingProofId,
      stateBeforeEditing: stateBeforeEditing,
      files: files ?? this.files,
      selectedAcceptedDocumentName:
          selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipProofId: scholarshipProofId ?? this.scholarshipProofId,
    );
  }
}

class EditingAdding extends StoreState with Adding, Editing {
  @override
  final String editingProofId;
  @override
  final StoreState stateBeforeEditing;
  @override
  final List<String> photoPaths;

  const EditingAdding({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required this.editingProofId,
    required this.stateBeforeEditing,
    required this.photoPaths,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required super.scholarshipProofId,
  });

  @override
  EditingAdding copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<String>? photoPaths,
    String? editingProofId,
    StoreState? stateBeforeEditing,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipProofId,
  }) {
    return EditingAdding(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ??
          this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId:
          selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      editingProofId: editingProofId ?? this.editingProofId,
      stateBeforeEditing: stateBeforeEditing ?? this.stateBeforeEditing,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName:
          selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipProofId: scholarshipProofId ?? this.scholarshipProofId,
    );
  }
}

class EditingAddingPdf extends StoreState with Adding, Editing {
  @override
  final String editingProofId;
  @override
  final StoreState stateBeforeEditing;
  @override
  final List<String> photoPaths;

  const EditingAddingPdf({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required this.editingProofId,
    required this.stateBeforeEditing,
    required this.photoPaths,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required super.scholarshipProofId,
  });

  @override
  EditingAddingPdf copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<String>? photoPaths,
    String? editingProofId,
    StoreState? stateBeforeEditing,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipProofId,
  }) {
    return EditingAddingPdf(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ??
          this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId:
          selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      editingProofId: editingProofId ?? this.editingProofId,
      stateBeforeEditing: stateBeforeEditing ?? this.stateBeforeEditing,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName:
          selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipProofId: scholarshipProofId ?? this.scholarshipProofId,
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
