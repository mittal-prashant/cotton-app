import 'dart:io';
import 'package:cotton/components/loading_widget.dart';
import 'package:cotton/components/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/provider.dart';

class UploadImageWidget extends StatefulWidget {
  const UploadImageWidget({super.key});

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  CroppedFile? _croppedFile;
  bool isImageUploaded = false;
  bool isBeingUploaded = false;
  late int length;
  late int width;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: TextButton.icon(
        onPressed: () => {
          showModalBottomSheet(
            context: context,
            builder: ((builder) => bottomSheet()),
          ),
        },
        label: const Text(
          "Upload Image",
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)))),
        icon: const Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
          size: 25.0,
        ),
      ),
      body: Center(
        child: isBeingUploaded
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isImageUploaded
                    ? [
                        Image(
                          image: FileImage(File(_croppedFile!.path)),
                          width: (ResponsiveWidget.isSmallScreen(context))
                              ? 300
                              : 600,
                          height: (ResponsiveWidget.isSmallScreen(context))
                              ? 300
                              : 600,
                          fit: BoxFit.fill,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Length: $length',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Width: $width',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ]
                    : const [
                        Text(
                          'Get Cotton Details',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Upload Image',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
              ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton(
              onPressed: () {
                takePhoto(ImageSource.camera);
                Navigator.pop(context);
                setState(() {
                  isBeingUploaded = true;
                });
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.camera,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Camera", style: TextStyle()),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                takePhoto(ImageSource.gallery);
                Navigator.pop(context);
                setState(() {
                  isBeingUploaded = true;
                });
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.image,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Gallery', style: TextStyle()),
                ],
              ),
            )
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    try {
      _imageFile = await _picker.pickImage(source: source, imageQuality: 15);
    } catch (e) {
      rethrow;
    }
    if (_imageFile != null) {
      if (!mounted) return;
      _croppedFile = await ImageCropper()
          .cropImage(sourcePath: _imageFile!.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(minimumAspectRatio: 1),
      ]);

      File finalImage = File(_croppedFile!.path);

      List response = await getImageDetails(finalImage);

      setState(() {
        if (response.isNotEmpty) {
          isBeingUploaded = false;
          isImageUploaded = true;
          length = response[0];
          width = response[1];
        }
      });
    }
  }
}
