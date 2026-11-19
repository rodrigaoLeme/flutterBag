class DeclarationTemplateFileEntity {
  final String url;
  final String filename;
  final String contentType;

  const DeclarationTemplateFileEntity({
    required this.url,
    required this.filename,
    this.contentType = 'application/pdf',
  });
}
