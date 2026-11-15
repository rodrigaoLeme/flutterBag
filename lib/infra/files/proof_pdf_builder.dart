import 'dart:io';
import 'dart:isolate';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:uuid/uuid.dart';

/// Junta as imagens, na ordem recebida, em um único PDF temporário.
Future<File> buildPdfFromImages(List<String> imagePaths) async {
  final bytes = await Isolate.run(() async {
    final doc = pw.Document();
    for (final path in imagePaths) {
      final image = pw.MemoryImage(await File(path).readAsBytes());
      doc.addPage(
        pw.Page(
          margin: pw.EdgeInsets.zero,
          build: (_) =>
              pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
        ),
      );
    }
    return doc.save();
  });
  final dir = await getTemporaryDirectory();
  return File('${dir.path}/${const Uuid().v4()}.pdf').writeAsBytes(bytes);
}
