import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  final String? imageUrl;
  final Uint8List? bytes;
  final Widget? errorWidget;
  final BoxFit? fit;

  const CachedImageWidget({
    super.key,
    this.imageUrl,
    this.bytes,
    this.errorWidget,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (bytes != null) {
      if (bytes?.isEmpty == true) {
        return errorWidget ?? const Icon(Icons.error);
      }
      return Image.memory(
        bytes!,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? const Icon(Icons.error);
        },
      );
    }
    if (imageUrl != null) {
      return CachedNetworkImage(
        fit: fit,
        imageUrl: imageUrl!,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) =>
            errorWidget ?? const Icon(Icons.error),
      );
    }
    return const SizedBox.shrink();
  }
}
