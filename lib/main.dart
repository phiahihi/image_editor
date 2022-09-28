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
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Welcome to Flutter', home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  File image = File('');

  Future selectImage() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource
            .gallery); //This opens the gallery and lets the user pick the image
    if (pickedFile == null) {
      return;
    }
    //Checks if the user did actually pick something

    setState(() {
      image = File(pickedFile.path);
    });
    //This is the image the user picked
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Flutter'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              selectImage().then((value) {
                if (image.path.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageScreen(
                        image: image,
                      ),
                    ),
                  );
                } else {
                  return;
                }
              });
            },
            child: const Text("pick image"),
          ),
        ],
      ),
    );
  }
}


// how to use
// ImageEditor.navigate(yourImage, onComplete: (image) {
// // do your handler here
// })