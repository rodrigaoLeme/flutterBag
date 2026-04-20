import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/params.dart';

abstract class StoreState {
  final String selectedProofId;
  final String selectedScholarshipProofDocumentId;
  final String selectedAcceptedDocumentId;
  final List<AcceptedDocumentFileViewModel> files;
  final String selectedAcceptedDocumentName;
  final String scholarshipReviewId;
  final Params getProofsWithPendencesParams;

  const StoreState({
    required this.selectedProofId,
    required this.selectedScholarshipProofDocumentId,
    required this.selectedAcceptedDocumentId,
    required this.files,
    required this.selectedAcceptedDocumentName,
    required this.scholarshipReviewId,
    required this.getProofsWithPendencesParams,
  });

  StoreState copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipReviewId,
    Params? getProofsWithPendencesParams,
  });
}

class Initial extends StoreState {
  const Initial({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipReviewId,
    Params? getProofsWithPendencesParams,
  }) : super(
          selectedAcceptedDocumentId: selectedAcceptedDocumentId ?? '',
          selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ?? '',
          selectedProofId: selectedProofId ?? '',
          files: files ?? const [],
          selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? '',
          scholarshipReviewId: scholarshipReviewId ?? '',
          getProofsWithPendencesParams: getProofsWithPendencesParams ?? proofReferenceParamsEmpty,
        );

  @override
  Initial copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipReviewId,
    Params? getProofsWithPendencesParams,
  }) {
    return Initial(
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
      files: files ?? this.files,
      getProofsWithPendencesParams: getProofsWithPendencesParams ?? this.getProofsWithPendencesParams,
      selectedAcceptedDocumentId: selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ?? this.selectedScholarshipProofDocumentId,
    );
  }
}

mixin Set on StoreState {}

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
    String? scholarshipReviewId,
    Params? getProofsWithPendencesParams,
  });
}

mixin Editing on StoreState {
  StoreState get stateBeforeEditing;
  String get originalAcceptedDocumentId;
}

class ConfirmEditing extends StoreState with Editing {
  @override
  final StoreState stateBeforeEditing;

  @override
  final String originalAcceptedDocumentId;

  const ConfirmEditing({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required this.stateBeforeEditing,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required super.scholarshipReviewId,
    required super.getProofsWithPendencesParams,
    required this.originalAcceptedDocumentId,
  });

  @override
  ConfirmEditing copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipReviewId,
    Params? getProofsWithPendencesParams,
    String? originalAcceptedDocumentId,
    StoreState? stateBeforeEditing
  }) {
    return ConfirmEditing(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ?? this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId: selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      stateBeforeEditing: stateBeforeEditing ?? this.stateBeforeEditing,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
      getProofsWithPendencesParams: getProofsWithPendencesParams ?? this.getProofsWithPendencesParams,
      originalAcceptedDocumentId: originalAcceptedDocumentId ?? this.originalAcceptedDocumentId,
    );
  }
}

class EditingSet extends StoreState with Set, Editing {
  @override
  final StoreState stateBeforeEditing;

  @override
  final String originalAcceptedDocumentId;

  const EditingSet({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required this.stateBeforeEditing,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required super.scholarshipReviewId,
    required super.getProofsWithPendencesParams,
    required this.originalAcceptedDocumentId,
  });

  @override
  EditingSet copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipReviewId,
    Params? getProofsWithPendencesParams,
    String? originalAcceptedDocumentId,
    StoreState? stateBeforeEditing,
  }) {
    return EditingSet(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ?? this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId: selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      stateBeforeEditing: stateBeforeEditing ?? this.stateBeforeEditing,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
      getProofsWithPendencesParams: getProofsWithPendencesParams ?? this.getProofsWithPendencesParams,
      originalAcceptedDocumentId: originalAcceptedDocumentId ?? this.originalAcceptedDocumentId,
    );
  }
}

class EditingAdding extends StoreState with Adding, Editing {
  @override
  final StoreState stateBeforeEditing;
  @override
  final List<String> photoPaths;
  @override
  final String originalAcceptedDocumentId;

  const EditingAdding({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required this.stateBeforeEditing,
    required this.photoPaths,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required super.scholarshipReviewId,
    required super.getProofsWithPendencesParams,
    required this.originalAcceptedDocumentId,
  });

  @override
  EditingAdding copyWith({
    String? selectedProofId,
    String? selectedScholarshipProofDocumentId,
    String? selectedAcceptedDocumentId,
    List<String>? photoPaths,
    StoreState? stateBeforeEditing,
    List<AcceptedDocumentFileViewModel>? files,
    String? selectedAcceptedDocumentName,
    String? scholarshipReviewId,
    Params? getProofsWithPendencesParams,
    String? originalAcceptedDocumentId,
  }) {
    return EditingAdding(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ?? this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId: selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      stateBeforeEditing: stateBeforeEditing ?? this.stateBeforeEditing,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
      getProofsWithPendencesParams: getProofsWithPendencesParams ?? this.getProofsWithPendencesParams,
      originalAcceptedDocumentId: originalAcceptedDocumentId ?? this.originalAcceptedDocumentId,
    );
  }
}

class EditingAddingPdf extends StoreState with Adding, Editing {
  @override
  final StoreState stateBeforeEditing;
  @override
  final List<String> photoPaths;
  @override
  final String originalAcceptedDocumentId;

  const EditingAddingPdf({
    required super.selectedProofId,
    required super.selectedScholarshipProofDocumentId,
    required super.selectedAcceptedDocumentId,
    required this.stateBeforeEditing,
    required this.photoPaths,
    required super.files,
    required super.selectedAcceptedDocumentName,
    required super.scholarshipReviewId,
    required super.getProofsWithPendencesParams,
    required this.originalAcceptedDocumentId,
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
    String? scholarshipReviewId,
    Params? getProofsWithPendencesParams,
    String? originalAcceptedDocumentId,
  }) {
    return EditingAddingPdf(
      selectedProofId: selectedProofId ?? this.selectedProofId,
      selectedScholarshipProofDocumentId: selectedScholarshipProofDocumentId ?? this.selectedScholarshipProofDocumentId,
      selectedAcceptedDocumentId: selectedAcceptedDocumentId ?? this.selectedAcceptedDocumentId,
      stateBeforeEditing: stateBeforeEditing ?? this.stateBeforeEditing,
      photoPaths: photoPaths ?? this.photoPaths,
      files: files ?? this.files,
      selectedAcceptedDocumentName: selectedAcceptedDocumentName ?? this.selectedAcceptedDocumentName,
      scholarshipReviewId: scholarshipReviewId ?? this.scholarshipReviewId,
      getProofsWithPendencesParams: getProofsWithPendencesParams ?? this.getProofsWithPendencesParams,
      originalAcceptedDocumentId: originalAcceptedDocumentId ?? this.originalAcceptedDocumentId,
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
