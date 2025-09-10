import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _cameraAvailable = true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Skip camera initialization on simulator or web
    if (kIsWeb || defaultTargetPlatform == TargetPlatform.iOS && !await _hasRealCamera()) {
      setState(() {
        _cameraAvailable = false;
      });
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() {
          _cameraAvailable = false;
        });
        return;
      }

      _controller = CameraController(
        cameras[0],
        ResolutionPreset.medium,
      );
      await _controller!.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print("Camera initialization failed: $e");
      setState(() {
        _cameraAvailable = false;
      });
    }
  }

  Future<bool> _hasRealCamera() async {
    try {
      final cameras = await availableCameras();
      return cameras.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        XFile picture = await _controller!.takePicture();
        print("Picture saved at: ${picture.path}");
        context.go('/results');
      } catch (e) {
        print("Error taking picture: $e");
      }
    } else {
      // Just go to results in simulator
      context.go('/results');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraAvailable) {
      return Scaffold(
        appBar: AppBar(title: const Text("Camera")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Camera not available on simulator.",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/results'),
                child: const Text("Go to Results"),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Capture Strip")),
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _takePicture,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(20),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Icon(Icons.camera_alt, size: 32, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
