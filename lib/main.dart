import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:d_app/classifier.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:d_app/classifier_quant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Classifier _classifier;

  var logger = Logger();

  File? _image;

  Image? _imageWidget;

  img.Image? fox;

  Category? category;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant();
  }

  void _predict() async {
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);

    setState(() {
      this.category = pred;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        title: const Text('potato_disease_classification'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
           Center(
            child: Text(
            category != null ? category!.label : '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: Colors.white),
            ),
          ),
          Center(
            child: image!=null ? Image.file(image!,width: 400,height: 400,fit:BoxFit.fill ,): FlutterLogo(size: 160,),
          ),
          Container(
            child: TextButton(
              style: flatButtonStyle,
                onPressed: (){ pickImage(ImageSource.camera); },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      SizedBox(width: 20),
                      Text('Camera',
                      style: TextStyle(fontWeight: FontWeight.bold,
                       color: Colors.white,
                        fontSize: 15,
                      ),
                      ),
                    ],
                  ),
                ),
            ),
          Container(
            child: TextButton(
              style: flatButtonStyle,
              onPressed: (){pickImage(ImageSource.gallery);},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_photo_alternate_sharp,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  SizedBox(width: 20),
                  Text('Gallery',
                    style: TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  File? image;

  Future pickImage(ImageSource source) async{
    final image = await ImagePicker().pickImage(source: source);
    if(image==null) return;

    final imageTemporary = File(image.path);
    setState(() {
      this.image=imageTemporary;

      _image = File(image.path);
      _imageWidget = Image.file(_image!);
      _predict();


    });
  }


  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

}



