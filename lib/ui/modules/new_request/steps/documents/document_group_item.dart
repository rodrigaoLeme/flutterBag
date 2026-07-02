enum DocumentGroupType {
  family,
  candidate,
  member,
}

class DocumentGroupItem {
  final String id;
  final String title;
  final DocumentGroupType type;
  final int totalDocuments;
  final int uploadedDocuments;

  const DocumentGroupItem({
    required this.id,
    required this.title,
    required this.type,
    required this.totalDocuments,
    this.uploadedDocuments = 0,
  });

  bool get isComplete => uploadedDocuments >= totalDocuments;

  DocumentGroupItem copyWith({
    int? uploadedDocuments,
  }) =>
      DocumentGroupItem(
        id: id,
        title: title,
        type: type,
        totalDocuments: totalDocuments,
        uploadedDocuments: uploadedDocuments ?? this.uploadedDocuments,
      );
}
