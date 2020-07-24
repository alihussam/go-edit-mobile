import 'package:flutter/material.dart';

class CurveWidget extends StatelessWidget {
  final double _height;
  final Color _color;
  CurveWidget(this._height, this._color);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BezierClipper(),
      child: Container(
        color: _color,
        height: _height,
      ),
    );
  }
}

class BezierClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height * 0.85); //vertical line
    path.cubicTo(size.width / 3, size.height, 2 * size.width / 3,
        size.height * 0.7, size.width, size.height * 0.85); //cubic curve
    path.lineTo(size.width, 0); //vertical line
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
