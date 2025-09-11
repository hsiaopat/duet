// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:isolate';
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import '../services/color_model_service.dart';
// import '../stores/result_store.dart';

// //we'll need this later on when we need to spawn a worker isolate for orchestration + messaging
// //spawn a dart isolate
// //creates an instance of colorservice inside isolate so heavy work doesn't block UI
// //handles passing frames in and results out

// class MLOrchestrator {
//   late Isolate _isolate;
//   late SendPort _sendPort;
//   final ReceivePort _receivePort = ReceivePort();
//   late StreamSubscription _receiveSub;

//   final ResultStore resultStore;

//   bool _isProcessing = false;

//   MLOrchestrator({required this.resultStore});

//   /// Spawn isolate and initialize TFLite service inside it
//   Future<void> spawnIsolate() async {
//     _isolate = await Isolate.spawn(_isolateEntry, _receivePort.sendPort);

//     // Wait for the isolate to send back its SendPort
//     _sendPort = await _receivePort.first as SendPort;

//     // Listen to results coming from the isolate
//     _receiveSub = _receivePort.listen((msg) {
//       if (msg is _ResultMessage) {
//         // Update the ResultStore with the latest predictions
//         resultStore.updateResults(msg.frameId, msg.predictions);
//       }
//     });
//   }

//   /// Send a frame to the isolate for processing
//   void processFrame(int frameId, Uint8List preprocessedBytes) {
//     if (!_isProcessing) {
//       _isProcessing = true;
//       _sendPort.send(_FrameMessage(frameId, preprocessedBytes));
//       _isProcessing = false;
//     }
//   }

//   /// Dispose isolate and clean up
//   Future<void> dispose() async {
//     _sendPort.send('dispose');
//     await _receiveSub.cancel();
//     _receivePort.close();
//     _isolate.kill(priority: Isolate.immediate);
//   }

//   /// Top-level isolate entrypoint
//   static void _isolateEntry(SendPort mainSend) {
//     final port = ReceivePort();
//     mainSend.send(port.sendPort);

//     final service = ColorModelService();
//     // Initialize TFLite service asynchronously
//     service.initialize().then((_) {
//       late StreamSubscription sub;
//       sub = port.listen((msg) async {
//         if (msg is _FrameMessage) {
//           final result = await service.predict(msg.bytes);
//           mainSend.send(_ResultMessage(msg.frameId, result));
//         } else if (msg == 'dispose') {
//           await sub.cancel();
//           port.close();
//           service.dispose();
//         }
//       });
//     });
//   }
// }

// /// Simple message class for sending frames to isolate
// class _FrameMessage {
//   final int frameId;
//   final Uint8List bytes;

//   _FrameMessage(this.frameId, this.bytes);
// }

// /// Message class for sending results back to main thread
// class _ResultMessage {
//   final int frameId;
//   final List<double> predictions;

//   _ResultMessage(this.frameId, this.predictions);
// }
