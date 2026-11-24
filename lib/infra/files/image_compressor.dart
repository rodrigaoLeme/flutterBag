import 'dart:io';
import 'dart:isolate';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

const _maxSide = 2400;
const _jpegQuality = 80;

/// Reduz e recomprime a imagem para envio. Em qualquer falha devolve o
/// arquivo original, para nunca bloquear o usuário.
Future<String> compressImageForUpload(String path) async {
  try {
    final source = File(path);
    final size = await source.length();
    final dir = (await getTemporaryDirectory()).path;
    // Nome estável: a mesma foto gera o mesmo arquivo.
    final outPath = '$dir/proof_${path.hashCode}_$size.jpg';
    if (await File(outPath).exists()) return outPath;

    await Isolate.run(() {
      final decoded = img.decodeImage(source.readAsBytesSync());
      if (decoded == null) throw const FormatException('imagem inválida');

      var image = img.bakeOrientation(decoded);
      final longest = image.width > image.height ? image.width : image.height;
      if (longest > _maxSide) {
        image = image.width >= image.height
            ? img.copyResize(image, width: _maxSide)
            : img.copyResize(image, height: _maxSide);
      }
      File(outPath)
          .writeAsBytesSync(img.encodeJpg(image, quality: _jpegQuality));
    });
    return outPath;
  } catch (_) {
    return path;
  }
}
