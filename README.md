# image_editor

### How to use

// Example

https://user-images.githubusercontent.com/89730025/192221098-c1703e41-09d7-41a5-baf5-992920131c07.mp4


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
