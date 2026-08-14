class DocumentRequirementItem {
  final String id;
  final String title;
  final bool isUploaded;

  const DocumentRequirementItem({
    required this.id,
    required this.title,
    this.isUploaded = false,
  });

  DocumentRequirementItem copyWith({
    bool? isUploaded,
  }) =>
      DocumentRequirementItem(
        id: id,
        title: title,
        isUploaded: isUploaded ?? this.isUploaded,
      );
}
