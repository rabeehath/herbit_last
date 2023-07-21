
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:herbit/public_user/prediction_result.dart';
import 'package:image_picker/image_picker.dart';
import 'package:herbit/public_user/homepage.dart';
import 'package:path/path.dart';
import 'package:http/http.dart'as http;

class Prediction extends StatefulWidget {
  const Prediction({Key? key}) : super(key: key);

  @override
  State<Prediction> createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {


  ImagePicker picker = ImagePicker();
  XFile? image;
  late final _filename;
  File? imageFile;
  late String storedImage;
  String text='';

  String imageUrl = '';
  Future<void> submitForm() async {

    var uri = Uri.parse('https://8b6b-2409-40f3-21-dde8-e99f-33ae-28a8-f165.ngrok-free.app/api/plant_detection'); // Replace with your API endpoint

    var request = http.MultipartRequest('POST', uri);

    final imageStream = http.ByteStream(imageFile!.openRead());
    final imageLength = await imageFile!.length();

    final multipartFile = http.MultipartFile(
      'image',imageStream,imageLength,
      filename: _filename ,
      // contentType: MediaType('image', 'jpeg'), // Replace with your desired image type
    );
    // print(_filename2);
    request.files.add(multipartFile);

    print(_filename);

    final response = await request.send();

    if (response.statusCode == 201) {
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseBody);
      var data = jsonResponse['data'];
      text=data['class_name'];
      print(text);
      Navigator.push(this.context, MaterialPageRoute(builder: (context)=>result(text: text)));
     /* Fluttertoast.showToast(
        msg:text,
        backgroundColor: Colors.grey,
      );*/

      print('Response: $responseBody');
      print('Form submitted successfully');

    } else {
      print('Error submitting form. Status code: ${response.statusCode}');
    }
  }
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Choose from"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: const Text("Gallery"),
                    onTap: () {
                      _getFromGallery();
                      Navigator.pop(context);
                      //  _openGallery(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  const Padding(padding: EdgeInsets.all(0.0)),
                  GestureDetector(
                    child: const Text("Camera"),
                    onTap: () {
                      _getFromCamera();

                      Navigator.pop(context);
                      //   _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("capture"),
        backgroundColor: Colors.teal[900],
        leading: IconButton( onPressed: (){ Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const homepage(),
            )); }, icon:const Icon(Icons. arrow_back),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              "Select image to upload",
              style: TextStyle(fontSize: 17),
            ),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              /* decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/bg.jpg')
                        )
                      ),*/
              child: imageFile == null
                  ? Container(
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        //    _getFromGallery();
                        _showChoiceDialog(context);
                      },
                      child: const Text("Upload Image"),
                    ),
                    Container(
                      height: 40.0,
                    ),
                  ],
                ),
              )
                  : Row(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(imageFile!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                    onPressed: () {
                      //    _getFromGallery();
                      _showChoiceDialog(context);

                    },
                    child: const Text("Upload Image"),
                  ),
                ],
              ),
            ),
          ),
       /*   ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.teal[900],
            ),
            onPressed: () async {
              *//* image = await picker.pickImage(source: ImageSource.gallery);
              setState(() {
                //update UI
              });*//*
              _getFromGallery();
            },
            child: Text("Pick from gallery",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          image == null ? Container() : Image.file(File(image!.path)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.teal[900],
            ),
            onPressed: () async {
              *//*    image = await picker.pickImage(source: ImageSource.camera);
              setState(() {
                //update UI
              });*//*
              _getFromCamera();
            },
            child: Text("Pick from camera",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          image == null ? Container() : Image.file(File(image!.path)),
        */  Padding(
          padding: const EdgeInsets.only(top:30.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.teal[900],
            ),
            onPressed: () {
              /* Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => symptoms()),
              );*/
              submitForm();
            },
            child: const Text("submit",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
        ),
        ],
      ),
    );

  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(()  {

        imageFile = File(pickedFile.path);
        _filename = basename(imageFile!.path);
        final nameWithoutExtension = basenameWithoutExtension(imageFile!.path);
        final extenion = extension(imageFile!.path);
        print("imageFile:$imageFile");
        print(_filename);
        print(nameWithoutExtension);
        print(extenion);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        _filename = basename(imageFile!.path).toString();
        final nameWithoutExtension = basenameWithoutExtension(imageFile!.path);
        final extenion = extension(imageFile!.path);
      });
    }
  }
}
