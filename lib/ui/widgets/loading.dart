import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadSpinner extends StatelessWidget {
  final double padding;
  final double size;

  LoadSpinner({this.size = 40, this.padding = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(padding),
        child: Center(
            child: SpinKitFadingCube(
          color: Theme.of(context).primaryColor,
          size: size,
        )));
  }
}
