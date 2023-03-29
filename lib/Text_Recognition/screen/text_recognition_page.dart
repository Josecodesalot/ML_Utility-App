import 'dart:io';

import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TextRecognition extends StatefulWidget {
  const TextRecognition({Key? key}) : super(key: key);

  @override
  State<TextRecognition> createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  File? _image;
  bool isScanning = false;
  String text = "";

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _image = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Text Recognition",
        ),
      ),
      backgroundColor: Colors.black87,
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            icon: Icons.camera_alt,
            iconColor: Colors.white,
            title: "Capture Image",
            titleStyle: GoogleFonts.getFont("Raleway",
                textStyle: TextStyle(color: Colors.white)),
            bubbleColor: Colors.pinkAccent,
            onPress: () async {
              if (await Permission.camera.isGranted) {
                getImage(ImageSource.camera);
                _animationController.reverse();
              } else if (await Permission.camera.isPermanentlyDenied ||
                  await Permission.camera.isRestricted) {
                const SnackBar(
                  content: Text(
                      'Sorry! Camera Permission is denied permanently. Kindly allow it from settings'),
                );
              } else {
                Permission.camera.request();
              }
            },
          ),
          Bubble(
            icon: Icons.photo,
            iconColor: Colors.white,
            title: "Choose From Gallery",
            titleStyle: GoogleFonts.getFont("Raleway",
                textStyle: TextStyle(color: Colors.white)),
            bubbleColor: Colors.pinkAccent,
            onPress: () {
              getImage(ImageSource.gallery);
              _animationController.reverse();
            },
          )
        ],
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        animation: _animation,
        iconColor: Colors.pinkAccent,
        backGroundColor: Colors.white,
        iconData: Icons.add,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
              child: _image != null
                  ? Image.file(
                      _image!,
                      width: 320.w,
                      height: 260.h,
                      fit: BoxFit.scaleDown,
                    )
                  : Image(
                      width: 320.w,
                      height: 260.h,
                      image: const AssetImage('assets/images/placeholder.png'),
                    ),
            ),
            GestureDetector(
              onTap: () {
                getTextFromImage();
                setState(() {
                  isScanning = true;
                });
              },
              child: Container(
                height: 40,
                width: 150,
                margin: EdgeInsets.only(bottom: 20, top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.blueAccent,
                ),
                child: isScanning
                    ? const Center(
                        child: SizedBox(
                          height: 23,
                          width: 23,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          "Scan Image",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Raleway',
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              height: 250.h,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: SelectableText(
                  text,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image == null) return;

    final tempImg = File(image.path);

    setState(
      () {
        _image = tempImg;
        text = "";
      },
    );
  }

  Future<void> getTextFromImage() async {
    final InputImage inputImage = InputImage.fromFile(_image!);
    final TextRecognizer textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    print(text);
    setState(
      () {
        isScanning = false;
        if (text == "") {
          this.text = "No Text Recognised";
        } else {
          this.text = text;
        }
      },
    );
  }
}
