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
  onPressed: () {
    selectImage().then(
        (value) {
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
                },
              );
            },
            child: const Text("pick image"),
          ),
 ```
 ### Used packages include:
 
screenshot: ^1.2.3

photo_view: ^0.14.0

image_picker: ^0.8.5+3

image_cropper: ^3.0.0

flutter_colorpicker: ^1.0.3

