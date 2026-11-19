class ProofDocumentFileUrlEntity {
  final String url;
  final String filename;
  final String contentType;

  const ProofDocumentFileUrlEntity({
    required this.url,
    required this.filename,
    this.contentType = 'application/pdf',
  });
}
