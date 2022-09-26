# image_editor

### How to use

// Select image
```
Future selectImage() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource
            .gallery); 
    if (pickedFile == null) {
      return;
    }
    setState(() {
      image = File(pickedFile.path);
    });
  }
```
// Navigate ImageScreen
```
TextButton(
            onPressed: () async {
              await selectImage().then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageScreen(
                        image: image,
                      ),
                    ),
                  ));
            },
            child: const Text("pick image"),
          ),
 ```
