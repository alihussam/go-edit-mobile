import 'dart:async';
import 'dart:io';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goedit/utils/file_helper.dart';

Widget buildFormField(
    {@required String labelText,
    @required Function onChanged,
    Function validator,
    bool obscureText = false,
    String initialValue,
    int maxLines = 1,
    controller}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 12),
    child: TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
          hintText: labelText,
          labelText: labelText,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          border: OutlineInputBorder()),
    ),
  );
}

Widget buildNumericOnlyFormField(
    {@required String labelText,
    @required Function onChanged,
    Function validator,
    String initialValue}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 12),
    child: TextFormField(
      onChanged: onChanged,
      validator: validator,
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      decoration: InputDecoration(
          hintText: labelText,
          labelText: labelText,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          border: OutlineInputBorder()),
    ),
  );
}

Widget buildSearchBar({
  @required Function onSearch,
  @required Function onCancelled,
  @required Color color,
  onItemFound,
}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: SearchBar(
          searchBarStyle: SearchBarStyle(
            padding: EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(30.0),
          ),
          minimumChars: 1,
          onSearch: onSearch,
          onCancelled: onCancelled,
          onItemFound: onItemFound),
    ),
  );
}

/// Single Image Input
class SingleImageInput extends StatefulWidget {
  final void Function(File) onImageSelect;
  final String placeHolderText;

  SingleImageInput(
      {this.onImageSelect, this.placeHolderText = 'Click to add image'});

  @override
  _SingleImageInputState createState() => _SingleImageInputState();
}

class _SingleImageInputState extends State<SingleImageInput> {
  StreamController<File> _selfStateController = StreamController<File>();

  @override
  void dispose() {
    _selfStateController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () async {
          File image = await FileHelper.pickImageFromGallery();
          if (image != null) {
            _selfStateController.sink.add(image);
            widget.onImageSelect(image);
          }
        },
        child: StreamBuilder(
          stream: _selfStateController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return Container(
                height: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 30,
                      child: Center(
                        child: Text(
                          widget.placeHolderText,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    Image.file(
                      snapshot.data,
                      fit: BoxFit.cover,
                      height: 150,
                    ),
                  ],
                ),
              );
            }
            return Container(
              height: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/placeholder.jpg'),
                ),
              ),
              child: Center(
                child: Text(
                  widget.placeHolderText,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
