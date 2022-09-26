# image_editor

### How to use

// Select image
Future selectImage() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource
            .gallery); 
    if (pickedFile == null) {
      return;
    }
    //Checks if the user did actually pick something

    setState(() {
      image = File(pickedFile.path);
    });
  }

// Navigate ImageScreen

return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Flutter'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              print(image);
              await selectImage();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageScreen(
                    image: image,
                  ),
                ),
              );
            },
            child: const Text("pick image"),
          ),
        ],
      ),
    );
