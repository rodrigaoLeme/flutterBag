enum ProofAttachmentType { image, pdf }

enum AttachmentCheck { ok, tooManyFiles, tooLarge }

class ProofAttachment {
  final String path;
  final String name;
  final int sizeBytes;
  final ProofAttachmentType type;

  const ProofAttachment({
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.type,
  });
}

class ProofAttachments {
  static const int maxFiles = 6;
  static const int maxBytes = 15 * 1024 * 1024;

  final List<ProofAttachment> items;
  const ProofAttachments([this.items = const []]);

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  List<ProofAttachment> get images =>
      items.where((a) => a.type == ProofAttachmentType.image).toList();
  List<ProofAttachment> get pdfs =>
      items.where((a) => a.type == ProofAttachmentType.pdf).toList();

  // Todas as imagens viram um único PDF
  int get outgoingFileCount => pdfs.length + (images.isEmpty ? 0 : 1);
  int get totalBytes => items.fold(0, (sum, a) => sum + a.sizeBytes);

  AttachmentCheck check(List<ProofAttachment> incoming) {
    final next = ProofAttachments([...items, ...incoming]);
    if (next.outgoingFileCount > maxFiles) return AttachmentCheck.tooManyFiles;
    if (next.totalBytes > maxBytes) return AttachmentCheck.tooLarge;
    return AttachmentCheck.ok;
  }

  ProofAttachments add(List<ProofAttachment> incoming) =>
      ProofAttachments([...items, ...incoming]);

  ProofAttachments remove(ProofAttachment attachment) => ProofAttachments(
        items.where((a) => a.path != attachment.path).toList(),
      );
}
