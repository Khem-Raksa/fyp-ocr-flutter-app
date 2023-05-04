import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:ocr_flutter/scanner.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'FYP OCR Demo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ required this.title}) ;
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<List<File>> pickImages(BuildContext context) async {

    List<File> images = [];

    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(
      imageQuality: 80
    );

    if(pickedImages!=null){
      images = pickedImages.map((pickedImage)=>File(pickedImage.path)).toList();
    }

    return images;
  }

  void goToScan(context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: ((context) =>  ScanningScreen()))
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title,style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              pickImages(context);
            }, child: const Text("Upload Pictures",style: TextStyle(color: Colors.white),)),
             ElevatedButton(onPressed: (){
              goToScan(context);
            }, child: const Text("Scan Picture",style: TextStyle(color: Colors.white))),
          ],
        )
        )
    );
  }
}