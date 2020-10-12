import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn, this.isLogin);
  final Function(File pickedImage) imagePickFn;
  final bool isLogin;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  void _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(
      source: source,
      imageQuality: 50,
      maxWidth: 150,
    );

    Navigator.of(context).pop();

    setState(() {
      _pickedImage = File(pickedFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  void _showBottomModal() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.photo_camera,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('Using Camera',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          )),
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                    ListTile(
                      focusColor: Theme.of(context).primaryColor,
                      leading: Icon(
                        Icons.photo,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        'Using Gallery',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.isLogin == true)
          Container(
            height: 50,
          ),
        if (widget.isLogin == false)
          Column(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              FlatButton.icon(
                onPressed: _showBottomModal,
                icon: Icon(Icons.photo_camera),
                label: Text('Add Image'),
              ),
            ],
          ),
        Positioned(
            top: -80,
            right: widget.isLogin ? 105 : 10,
            child: Container(
              child: CircleAvatar(
                  radius: 60,
                  child: _pickedImage == null
                      ? Icon(
                          widget.isLogin ? Icons.flash_on : Icons.message,
                          size: 60,
                        )
                      : null,
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
