import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  @required onSearch,
  @required onCancelled,
  onItemFound,
}) {
  return Container(
    height: 150,
    padding: EdgeInsets.symmetric(vertical: 10),
    child: SearchBar(
        onSearch: onSearch, onCancelled: onCancelled, onItemFound: onItemFound),
  );
}
