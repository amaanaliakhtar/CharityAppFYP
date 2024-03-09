import 'dart:io';
import 'package:charity_app/authentication/login_screen.dart';
import 'package:charity_app/screens/donation/user_donations.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  bool textScanning = false;
  XFile? uploadedImage;
  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          title: const Text(
            "Charity Navigator",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyDonations(),
                  ),
                );
              },
              icon: Icon(
                Icons.book,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      actions: [
                        SignedOutAction((context) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.person,
              ),
            )
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (textScanning) const CircularProgressIndicator(),
                  if (!textScanning && uploadedImage == null)
                    Container(
                      width: 300,
                      height: 300,
                      color: Colors.grey,
                    ),
                  if (uploadedImage != null)
                    Image.file(File(uploadedImage!.path)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      uploadOptionButton(Icon(Icons.image_rounded), "Gallery"),
                      uploadOptionButton(Icon(Icons.camera_enhance), "Camera"),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      scannedText,
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              )),
        ));
  }

  void uploadImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        textScanning = true;
        uploadedImage = image;
        setState(() {});
        textRecognition(image);
      }
    } catch (e) {
      textScanning = false;
      uploadedImage = null;
      scannedText = "Error whilst uploading image";
      setState(() {});
    }
  }

  Widget uploadOptionButton(Icon icon, String buttonText) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.only(top: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          shadowColor: Colors.grey,
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          if (buttonText == "Camera") {
            uploadImage(ImageSource.camera);
          } else if (buttonText == "Gallery") {
            uploadImage(ImageSource.gallery);
          }
          //getImage(ImageSource.camera);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              Text(
                buttonText,
                style: const TextStyle(fontSize: 15, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  void textRecognition(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}
