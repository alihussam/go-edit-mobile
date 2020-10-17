import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildFormField(
    {@required String labelText,
    @required Function onChanged,
    Function validator,
    bool obscureText = false,
    String initialValue,
    int maxLines = 1}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 12),
    child: TextFormField(
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
