import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);
  final Function(File pickedImage) imagePickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      _pickedImage = File(pickedFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            FlatButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo_camera),
              label: Text('Add Image'),
            ),
          ],
        ),
        Positioned(
            top: -80,
            child: Container(
              child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      _pickedImage != null ? FileImage(_pickedImage) : null,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue),
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(2.0), // borde width
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF), // border color
                shape: BoxShape.circle,
              ),
            )),
      ],
      overflow: Overflow.visible,
    );
  }
}
