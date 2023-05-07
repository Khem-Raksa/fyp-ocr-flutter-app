import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';

class ScanningScreen extends StatefulWidget {
  @override
  _ScanningScreenState createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  final _documentScannerController = DocumentScannerController();


  //Send to OCR server
  void _onDocumentScanned(document) {
    // Handle the scanned document
    print('Scanned document: $document');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DocumentScanner(
        controller: _documentScannerController,
        onSave: _onDocumentScanned,
        resolutionCamera: ResolutionPreset.high,
        initialCameraLensDirection: CameraLensDirection.back,
        // Add any additional configuration options here
      ),
    );
  }
}
