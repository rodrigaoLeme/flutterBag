class DocumentRequirementItem {
  final String id;
  final String title;
  final String? description;
  final bool isUploaded;

  const DocumentRequirementItem({
    required this.id,
    required this.title,
    this.description,
    this.isUploaded = false,
  });

  DocumentRequirementItem copyWith({
    bool? isUploaded,
  }) =>
      DocumentRequirementItem(
        id: id,
        title: title,
        description: description,
        isUploaded: isUploaded ?? this.isUploaded,
      );
}
