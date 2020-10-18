// import 'package:flutter_masked_text/flutter_masked_text.dart';

mixin FieldValidators {
  String validateRequired(String value) {
    if (value.trim().length < 3)
      return 'This field is required';
    else
      return null;
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.trim().toLowerCase())) return 'Invalid email';
    return null;
  }

  String validatePassword(String value) {
    if (value.length < 8) return "Password length must be 8 to 255 characters";
    return null;
  }

  String validateJobTitle(String value) {
    if (value.trim().length == 0 || value.trim().length > 20)
      return "Job title is required and should not be greater than 20 characters";
    return null;
  }

  String validateBio(String value) {
    if (value.trim().length == 0 || value.trim().length > 250)
      return "Bio is required and should not be greater than 250 characters";
    return null;
  }

  // String validatePhone(String value) {
  //   Pattern pattern = r'^(?:(([+]|00)92)|0)((3[0-6][0-9]))(\d{7})$';
  //   RegExp regExp = new RegExp(pattern);
  //   if (value.isEmpty) return 'Phone is required';
  //   if (!regExp.hasMatch(value)) return 'Invalid phone';
  //   return null;
  // }

  // var phoneMask = new MaskedTextController(mask: '00000000000');
}
