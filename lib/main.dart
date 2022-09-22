import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test1/image_flutter/image_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ImagePicker _picker = ImagePicker();
  late File image = File('');

  void selectImage() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource
            .gallery); //This opens the gallery and lets the user pick the image
    if (pickedFile == null) {
      return;
    }
    //Checks if the user did actually pick something

    setState(() {
      image = (File(pickedFile.path));
    }); //This is the image the user picked
    print(image);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: ImageScreen(
          image: image,
        ),
      ),
    );
  }
}
