import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:screenshot/screenshot.dart';

class ImageScreen extends StatefulWidget {
  late File image;
  ImageScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool writeText = false;
  bool boldText = false;
  final TextEditingController _text = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  List<String> listFont = [
    'Avenir',
    'AvenirSemiBold',
    'AvenirMediumItalic',
    'AvenirLight'
  ];
  String? fontText;
  int? value;
  String complete = '';
  bool turnOffAllBtn = false;
  double angle = 0;
  bool editCapture = false;
  bool hideText = false;
  Offset _offset = const Offset(0, 0);
  late Offset _startingFocalPoint;
  late Offset _previousOffset;
  final double _previousZoom = 1.0;
  final double _zoom = 1.0;
  Size containerSize = const Size(100, 50);

  void _handleScaleStart(ScaleStartDetails details) {
    setState(() {
      _startingFocalPoint = details.focalPoint;
      _previousOffset = _offset;
    });
    if (details.pointerCount == 2) {
      setState(() {
        angle;
      });
    }
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      // Ensure that item under the focal point stays in the same place despite zooming
      final Offset normalizedOffset =
          (_startingFocalPoint - _previousOffset) / _previousZoom;
      _offset = details.focalPoint - normalizedOffset * _zoom;
      _offset.dy;
    });
    if (details.pointerCount == 2) {
      setState(() {
        angle = details.rotation;
      });
    }
  }

  Future<void> _cropImage() async {
    if (widget.image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: widget.image.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            backgroundColor: Colors.blue,
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          widget.image = File(croppedFile.path);
        });
      }
    }
  }

  showCapturedWidget(BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                turnOffAllBtn = false;
                writeText = true;
              });
              Navigator.pop(context);
            },
          ),
          title: const Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage.isNotEmpty
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Screenshot(
          controller: screenshotController,
          child: Center(
            child: Stack(
              children: [
                PhotoView(
                  imageProvider: FileImage(widget.image),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  enableRotation: true,
                ),
                if (!writeText && !turnOffAllBtn)
                  Positioned(
                    child: Container(
                      color: !writeText
                          ? Colors.black.withOpacity(0.5)
                          : Colors.transparent,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 50,
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.abc,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      boldText = !boldText;
                                    });
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.blueAccent),
                                  child: const Text(
                                    'Xong',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      complete = _text.text;
                                      writeText = !writeText;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: TextField(
                                  controller: _text,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type here...',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 20,
                                  minLines: 1,
                                  style: TextStyle(
                                    fontFamily: fontText ?? 'Avenir',
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: boldText
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildFonts(index, () {
                                    setState(() {
                                      value = index;
                                      fontText = listFont[index];
                                    });
                                  });
                                },
                                itemCount: listFont.length,
                              ),
                            )
                          ],
                        ),
                      )),
                    ),
                  ),
                if (writeText)
                  Positioned(
                    top: _offset.dy,
                    left: _offset.dx,
                    child: GestureDetector(
                      onScaleStart: _handleScaleStart,
                      onScaleUpdate: _handleScaleUpdate,
                      child: Transform.rotate(
                        angle: angle,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                complete,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: boldText
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: Colors.white,
                                  fontFamily: fontText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (writeText && !turnOffAllBtn)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Column(
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              maximumSize: const Size(100, 50)),
                          child: Row(children: const [
                            Text(
                              'Văn bản',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.picture_as_pdf,
                              color: Colors.white,
                            ),
                          ]),
                          onPressed: () {
                            setState(() {
                              writeText = !writeText;
                            });
                            print(writeText);
                          },
                        ),
                        TextButton(
                          onPressed: _cropImage,
                          child: Row(children: const [
                            Text(
                              'Cắt ảnh',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Icon(
                              Icons.cut_outlined,
                              color: Colors.white,
                            )
                          ]),
                        ),
                      ],
                    ),
                  ),
                if (writeText && !turnOffAllBtn)
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueAccent),
                      child: const Text(
                        'Share',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          turnOffAllBtn = true;
                          writeText = true;
                          hideText = false;
                        });
                        screenshotController
                            .capture()
                            .then((capturedImage) async {
                          showCapturedWidget(context, capturedImage!);
                        }).catchError((onError) {
                          print(onError);
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFonts(int index, void Function()? onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: index == value
                ? Colors.white.withOpacity(0.7)
                : Colors.black.withOpacity(0.7)),
        onPressed: onPressed,
        child: Text(
          'A a',
          style: TextStyle(
              fontFamily: fontText,
              color: index == value ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
