import 'document_proof_preview_page.dart';

class DocumentUploadRecord {
  final String fileName;
  final String? filePath;
  final String? selectedDocumentType;
  final String? value;
  final Map<String, DocumentProofPreviewResult> optionFiles;

  const DocumentUploadRecord({
    this.fileName = '',
    this.filePath,
    this.selectedDocumentType,
    this.value,
    this.optionFiles = const {},
  });

  bool get hasFile => fileName.isNotEmpty || optionFiles.isNotEmpty;

  DocumentUploadRecord copyWith({
    String? fileName,
    String? filePath,
    String? selectedDocumentType,
    String? value,
    Map<String, DocumentProofPreviewResult>? optionFiles,
  }) =>
      DocumentUploadRecord(
        fileName: fileName ?? this.fileName,
        filePath: filePath ?? this.filePath,
        selectedDocumentType:
            selectedDocumentType ?? this.selectedDocumentType,
        value: value ?? this.value,
        optionFiles: optionFiles ?? this.optionFiles,
      );

  factory DocumentUploadRecord.fromPreview(DocumentProofPreviewResult result) =>
      DocumentUploadRecord(
        fileName: result.fileName,
        filePath: result.filePath,
      );
}
