import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Decode jpeg bytes and resize to [targetW]x[targetH], return flattened RGB Uint8List
Uint8List preprocessJpegForModel(Uint8List jpegBytes, int targetW, int targetH) {
  final image = img.decodeImage(jpegBytes);
  if (image == null) throw Exception('Unable to decode image');

  // If card detection/warp is available, do it prior to this step.
  final resized = img.copyResize(image, width: targetW, height: targetH, interpolation: img.Interpolation.linear);

  final out = Uint8List(targetW * targetH * 3);
  int idx = 0;
  for (int y = 0; y < targetH; y++) {
    for (int x = 0; x < targetW; x++) {
      final p = resized.getPixel(x, y);
      out[idx++] = img.getRed(p);
      out[idx++] = img.getGreen(p);
      out[idx++] = img.getBlue(p);
    }
  }
  return out;
}
