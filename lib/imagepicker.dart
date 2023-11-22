import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagepickertask/pageview_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? image;
  late String imagePath;

  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      print('Gallery Image Path:');
      print(image.path);

      imagePath = image.path;

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick Image: $e');
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      print('Camera Image Path:');
      print(image.path);

      imagePath = image.path;

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  _uploadImageDialog(BuildContext context) async {
    final pickedImage = await showDialog<ImageSource>(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: Text('Upload Image'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromRGBO(15, 53, 73, 1)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      final imageTemp = File(image.path);
                      print('Gallery Image Path: ${image.path}');
                      setState(() {
                        this.image = imageTemp;
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Gallery'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (image != null) {
                      final imageTemp = File(image.path);
                      print('Camera Image Path: ${image.path}');
                      setState(() {
                        this.image = imageTemp;
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Camera'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PageViewImage(),
                    ));
                    print('Display image from Directory');
                  },
                  child: Text('Directory'),
                )
              ],
            ),
          ),
        );
      },
    );

    if (pickedImage != null) {
      // Handle the picked image (optional)
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Image Picker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(
                  'Share Gallery Image',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  'Share Camera Image',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              // PopupMenuItem(
              //   value: 3,
              //   child: Text(
              //     'Share Asset Image',
              //     style: TextStyle(fontSize: 20),
              //   ),
              // ),
            ],
             onSelected: (value) {
               if (value == 1) {
                 share();
               }
            //   if (value == 2) {
            //     shareEmailid();
            //   }
            //   if (value == 3) {
            //     shareAddress();
            //   }
            //   if (value == 4) {
            //     shareAll();
            //   }
             },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Padding(
                    padding: EdgeInsets.only(left: 130.0),
                    child: ClipOval(
                      child: Image.file(
                        image!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : FlutterLogo(),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              height: 40,
              width: 200,
              child: ElevatedButton(
                  onPressed: () {
                    _uploadImageDialog(context);
                  },
                  child: Text('+Add/display Photo')),
            ),
          ],
        ),
      ),
    );
  }
  share() async {
    if (image != null) {
      final imageFile = File(imagePath);
      await Share.shareFiles([imageFile.path], text: 'Image shared');
    } else {
      // Handle the case when there's no image to share.
    }
  }

}
