import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goedit/utils/file_helper.dart';

class ProfileViewImagePicker extends StatefulWidget {
  final String imageUrl;
  final Function(File image) onImageSelect;
  final bool isViewOnly;

  ProfileViewImagePicker(
      {this.imageUrl, this.onImageSelect, this.isViewOnly = false});

  @override
  _ProfileViewImagePickerState createState() => _ProfileViewImagePickerState();
}

class _ProfileViewImagePickerState extends State<ProfileViewImagePicker> {
  StreamController<File> _imageController = StreamController<File>();

  @override
  void dispose() {
    _imageController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.isViewOnly) return;
        File image = await FileHelper.pickImageFromGallery();
        if (image != null) {
          widget.onImageSelect(image);
          _imageController.add(image);
        }
      },
      child: ClipOval(
        child: StreamBuilder(
          stream: _imageController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Image.file(
                snapshot.data,
                height: 100.0,
                width: 100.0,
                fit: BoxFit.cover,
              );
            }
            return Image.network(
              widget.imageUrl,
              height: 100.0,
              width: 100.0,
              fit: BoxFit.fill,
            );
          },
        ),
      ),
    );
  }
}
