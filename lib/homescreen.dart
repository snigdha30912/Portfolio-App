import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var controller = TextEditingController();
  File _imageFile;
  CollectionReference data = FirebaseFirestore.instance.collection('data');
  Future<void> upload(File image, String name) {
    // Call the user's CollectionReference to add a new user

    return data
        .add({
          'name': name, // John Doe
          'image': Blob(
              image.readAsBytesSync().buffer.asUint8List()), // Stokes and Sons
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            padding: EdgeInsets.all(32),
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              Container(
                height: 200,
                width: 200,
                padding: EdgeInsets.all(32),
                child: GestureDetector(
                  child: (_imageFile != null)
                      ? Image.file(
                          _imageFile,
                          height: 200,
                          width: 200,
                        )
                      : Image(
                          image: AssetImage('assets/bokuto.jpg'),
                        ),
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ),
              Container(
                  height: 100,
                  width: 400,
                  child: EditableText(
                      controller: this.controller,
                      focusNode: FocusNode(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                      cursorColor: Colors.orange,
                      backgroundCursorColor: Colors.grey)),
              IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () => {upload(_imageFile, controller.text)})
            ])));
  }
}
