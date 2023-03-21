import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:ocr_flutter/scanner.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OCR Engine System',
      theme: ThemeData(
        primarySwatch:   const MaterialColor( 0xFF2979BF, // default color, normally matches [500]
    <int, Color>{
      50:  Color(0xFF2979BF),
      100: Color(0xFF2979BF),
      200: Color(0xFF2979BF),
      300: Color(0xFF2979BF),
      400: Color(0xFF2979BF),
      500: Color(0xFF2979BF), // same as primary
      600: Color(0xFF2979BF),
      700: Color(0xFF2979BF),
      800: Color(0xFF2979BF),
      900: Color(0xFF2979BF),
    },),
      ),
      home: MyHomePage(title: 'OCR Demo App - Made with ❤'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

   late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final ImagePicker imagePicker = ImagePicker();
  var _image;

  List<XFile> imageFiles = [];
  dynamic openImages() async {
    imageFiles.clear();
    final List<XFile> selectedImage = await imagePicker.pickMultiImage();
    setState(() {
    imageFiles.addAll(selectedImage);
    });
    return imageFiles[0];
  }

  void captureImage() async{
    XFile? image = await imagePicker.pickImage(source: ImageSource.camera,imageQuality: 50);
    if(image!=null){
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<dynamic> Upload(image) async{
    print("joey");
    var request = await http.MultipartRequest('POST',
        Uri.parse("http://localhost:8000/ocr"));
    Map <String,String> headers = {"Content-type" : "multipart/form-data"};
      request.files.add(
      http.MultipartFile(
        'image',
        image.asStream(),
        image.lengthSync(),
        filename: "filename",
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);
    request.send().then((value) => print(value.statusCode));
    return;
  }

  @override
  Widget build(BuildContext context) {
    final cameraPreview = CameraPreview(controller);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
               child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: (){
              var image = openImages();
              Upload(image);
            }, child: const Text("🖼 Upload Images")),
            ElevatedButton(onPressed: (){
              print("Hiii");
              print(cameraPreview);
              print("Hey");
              Get.to(()=>ScannerPage(cameraPreview:cameraPreview));
            },child:const Text("📷 OCR - Scan"))
          ],
        ),
      ),
    );
  }
}
