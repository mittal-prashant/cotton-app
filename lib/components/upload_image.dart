import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cotton/components/responsive_widget.dart';
import 'package:cotton/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loading_widget.dart';

class UploadImageWidget extends StatefulWidget {
  const UploadImageWidget({super.key});

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  CroppedFile? _croppedFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: <Widget>[
        (_croppedFile == null)
            ? CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                radius: (ResponsiveWidget.isSmallScreen(context)) ? 50.0 : 80,
                child: CachedNetworkImage(
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius:
                        (ResponsiveWidget.isSmallScreen(context)) ? 50.0 : 80,
                    backgroundImage: imageProvider,
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  imageUrl:
                      "https://lh3.googleusercontent.com/a/ACg8ocIlLR3UZAMJ_thWFAI2M0ra56Z0dJBh9RzkZy9AhOnt=s96-c",
                  placeholder: (context, url) => const LoadingWidget(
                    isImage: true,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/person.png',
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),
              )
            : CircleAvatar(
                radius: (ResponsiveWidget.isSmallScreen(context)) ? 50.0 : 80,
                backgroundImage: FileImage(File(_croppedFile!.path)),
                backgroundColor: Colors.blueAccent,
              ),
        Positioned(
          bottom: 0.0,
          right: -10.0,
          child: MaterialButton(
            onPressed: () => {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              ),
            },
            minWidth: 0,
            color: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 25.0,
            ),
          ),
        ),
      ]),
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
      final pickedFile =
          await _picker.pickImage(source: source, imageQuality: 15);
      setState(() {
        _imageFile = pickedFile;
      });
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

      setState(() {});
    }
  }
}
