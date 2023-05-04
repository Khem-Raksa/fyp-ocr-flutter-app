import 'dart:async';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:ocr_flutter/capturedImage.dart';

class ScanningScreen extends StatefulWidget {
  @override
  _ScanningScreenState createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen>
    with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  void _captureAndShowImage(BuildContext context) async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=>CapturedImageScreen(image: image))
      );
    } catch(e){
      print('Error capturing image:  $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(_controller),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: ScanningOverlay(),
                  ),
                ),
              ],
              
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class ScanningOverlay extends CustomPainter {
  final Color overlayColor = Color.fromRGBO(0, 0, 0, 0.6);
  final Color borderColor = Colors.white;
  final double borderWidth = 2.0;
  final double borderRadius = 20.0;
  final double padding = 20.0;
  final double boxWidth = 300.0;
  final double boxHeight = 600.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      (size.width - boxWidth) / 2,
      (size.height - boxHeight) / 2,
      boxWidth,
      boxHeight,
    );

    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final borderPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        rect.inflate(padding),
        Radius.circular(borderRadius),
      ));

    final overlayPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      borderPath,
    );

    canvas.drawPath(overlayPath, paint);
    canvas.drawPath(borderPath, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
