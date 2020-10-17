import 'dart:convert';
import 'package:goedit/models/user.dart';
import 'package:goedit/utils/request.dart';

class UserProv {
  /// Update user profile provider
  static Future<Map> updateProfile(String accessToken, User user) async {
    try {
      var data = await RequestClient.post('user/updateProfile',
          headers: {'authorization': accessToken},
          jsonEncodedBody: json.encode(user.toJson()));

      return {'profile': User.fromJson(data['data'])};
    } catch (exc) {
      print('exc here in update profile provider');
      print(exc);
      if (exc.message != null) print(exc.message);
      throw exc;
    }
  }
}
