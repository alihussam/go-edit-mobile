import 'dart:io';
import 'package:goedit/models/user.dart';
import 'package:goedit/utils/request.dart';

class UserProv {
  /// Update Profile Picture
  static Future<Map> updateProfilePicture(String accessToken, User user) async {
    try {
      Map<String, String> headers = {'authorization': accessToken};
      List<File> files = List<File>();

      if (user.profileImage != null) {
        files.add(user.profileImage);
      }

      var data = await RequestClient.postMultiPart('user/updateProfilePicture',
          headers: headers, files: files);

      return {'profile': User.fromJson(data['data'])};
    } catch (exc) {
      print('exc here in update profile picture provider');
      print(exc.toString());
      if (exc.message != null) print(exc.message);
      throw exc;
    }
  }

  /// Update user profile provider
  static Future<Map> updateProfile(String accessToken, User user) async {
    try {
      Map<String, String> headers = {'authorization': accessToken};
      Map<String, String> body = Map<String, String>();
      List<File> files = List<File>();

      if (user.portfolioImages != null && user.portfolioImages.length > 0) {
        files.addAll(user.portfolioImages);
      }

      // convert map to string, string
      user.toJson().forEach((key, value) => body[key] = value?.toString());

      var data = await RequestClient.postMultiPart('user/updateProfile',
          headers: headers, payload: body, files: files);

      return {'profile': User.fromJson(data['data'])};
    } catch (exc) {
      print('exc here in update profile provider');
      print(exc.toString());
      if (exc.message != null) print(exc.message);
      throw exc;
    }
  }
}
