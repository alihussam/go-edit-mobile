import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goedit/utils/file_helper.dart';

class GridViewImagePicker extends StatefulWidget {
  final List<String> imageUrls;
  final bool isViewModeOnly;

  GridViewImagePicker({@required this.imageUrls, this.isViewModeOnly = false});

  @override
  _GridViewImagePickerState createState() => _GridViewImagePickerState();
}

class _GridViewImagePickerState extends State<GridViewImagePicker> {
  List<File> _images = List<File>();

  @override
  Widget build(BuildContext context) {
    onAddImage() async {
      File image = await FileHelper.pickImageFromGallery();
      if (image != null) {
        _images.add(image);
        this.setState(() {});
      }
    }

    return Container(
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1,
        // +1 is for an extra add box
        children: [
          // first generate widgets for image urls
          ...List.generate(widget.imageUrls.length, (index) {
            return Container(
              margin: EdgeInsets.all(10),
              // semanticContainer: true,
              // clipBehavior: Clip.antiAliasWithSaveLayer,
              // child: Image.network(
              //   widget.imageUrls.elementAt(index),
              //   fit: BoxFit.fill,
              // ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    widget.imageUrls.elementAt(index),
                  ),
                ),
              ),
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(10.0),
              // ),
              // elevation: 5,
            );
          }),
          // only spread file upload etc if update mode
          ...(!widget.isViewModeOnly
              ? [
                  // now generate widgets for selected images
                  ...List.generate(_images.length, (index) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      // semanticContainer: true,
                      // clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.file(
                        _images.elementAt(index),
                        fit: BoxFit.cover,
                      ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10.0),
                      // ),
                      // elevation: 5,
                    );
                  }),
                  // finally generate an item for adding a picture
                  ...[
                    Card(
                      margin: EdgeInsets.all(10),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: InkWell(
                        onTap: onAddImage,
                        child: Container(
                          child: Center(
                            child: Icon(Icons.add),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                    ),
                  ],
                ]
              : []),
        ],
      ),
    );
  }
}
