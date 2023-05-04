import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CapturedImageScreen extends StatefulWidget {

  final XFile image;
  const CapturedImageScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build (BuildContext context){
     return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image'),
      ),
      body: Image.file(File(image.path)),
    );
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}