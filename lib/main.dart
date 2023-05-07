import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_flutter/result_page.dart';
import 'package:ocr_flutter/scanner.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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

  Future<void> sendImagesToOCR(List<File> files) async {
    // Send Images to OCR
    print("Say Hi");
    var url = Uri.parse('http://yourflaskserver.com/ocr'); // Replace with your Flask server URL
    var request = http.MultipartRequest('POST', url);

  for (var file in files) {
    print(file);
    var stream = http.ByteStream(file.openRead());
    var length = await file.length();
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: file.path.split('/').last);
    request.files.add(multipartFile);
  }

  var response = await request.send();

  if (response.statusCode == 200) {
    print('Images sent successfully to OCR');
  } else {
    print('Error sending images to OCR: ${response.statusCode}');
  }
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("FYP OCR Demo App",style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () async {
              var images = await pickImages(context);
              sendImagesToOCR(images);
              Get.to(const ResultPage(ResultPageText: "Hello this is result page"));

            }, child: const Text("Upload Pictures",style: TextStyle(color: Colors.white),)),
             ElevatedButton(onPressed: (){
              goToScan(context);
              Get.to(const ResultPage(ResultPageText: "Result After Scan"));

            }, child: const Text("Scan Picture",style: TextStyle(color: Colors.white))),
          ],
        )
        )
    );
  }
}