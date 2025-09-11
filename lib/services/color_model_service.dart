import 'package:image/image.dart' as img;

class ColorModelService {
  // Returns average color as an int (image package format)
  int _averageColor(img.Image image) {
    int r = 0, g = 0, b = 0;
    final w = image.width;
    final h = image.height;

    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        final pixel = image.getPixel(x, y);
        r += img.getRed(pixel);
        g += img.getGreen(pixel);
        b += img.getBlue(pixel);
      }
    }

    final count = w * h;
    return img.getColor(r ~/ count, g ~/ count, b ~/ count);
  }

  // Convert an int (image package color) to a label
  String _colorToLabel(int color) {
    final r = img.getRed(color);
    final g = img.getGreen(color);
    final b = img.getBlue(color);

    if (r > 200 && g < 50 && b < 50) return "High";
    if (r < 50 && g > 200 && b < 50) return "Low";
    return "Normal";
  }

  // Public method to detect label
  String detectColorLabel(img.Image image) {
    final avgColorInt = _averageColor(image); // int
    return _colorToLabel(avgColorInt);
  }
}
