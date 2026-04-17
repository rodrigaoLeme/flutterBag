import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

extension ImageColorExtension on img.Image {
  Color getAverageColor() {
    double red = 0.0, green = 0.0, blue = 0.0;
    int count = width * height;

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = getPixel(x, y);

        red += (pixel.r.toInt()) & 0xFF;
        green += (pixel.g.toInt()) & 0xFF;
        blue += pixel.b.toInt() & 0xFF;
      }
    }

    // Calculating the average color
    return Color.fromARGB(
      255,
      (red / count).round(),
      (green / count).round(),
      (blue / count).round(),
    );
  }
}
