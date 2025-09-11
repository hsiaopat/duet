import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import '../services/color_model_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  bool _isDetecting = false;
  String _colorLabel = "";
  final ColorModelService _colorService = ColorModelService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera =
        cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await _cameraController!.initialize();

    // Start real-time image stream
    _cameraController!.startImageStream(_processCameraImage);

    setState(() {});
  }

  void _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final convertedImage = _convertYUV420ToImage(image);
      final label = _colorService.detectColorLabel(convertedImage);

      setState(() {
        _colorLabel = label;
      });
    } catch (e) {
      debugPrint("Error detecting color: $e");
    } finally {
      _isDetecting = false;
    }
  }

  img.Image _convertYUV420ToImage(CameraImage image) {
    // Convert YUV420 to RGB (image package) - simplified
    final width = image.width;
    final height = image.height;
    final img.Image imgImage = img.Image(width, height);

    // Use the first plane (Y plane) for simplicity (approximates intensity)
    final Uint8List bytes = image.planes[0].bytes;
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = bytes[y * width + x];
        imgImage.setPixel(x, y, img.getColor(pixel, pixel, pixel));
      }
    }

    return imgImage;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: Stack(
        children: [
          CameraPreview(_cameraController!),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                color: Colors.black54,
                child: Text(
                  "Detected: $_colorLabel",
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
