import 'dart:convert';
import 'dart:io';
import 'package:goedit/models/metaData.dart';
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
      // user.toJson().forEach((key, value) => body[key] = json.encode(value));
      if (user.name != null) {
        // body['name'] = json.encode(user.name);
        body['firstName'] = user.name.firstName;
        body['lastName'] = user.name.lastName;
        if (user.name.middleName != null && user.name.middleName != '') {
          body['middleName'] = user.name.middleName;
        }
      }

      if (user.freelancerProfile != null) {
        if (user.freelancerProfile.jobTitle != null &&
            user.freelancerProfile.jobTitle != '') {
          body['jobTitle'] = user.freelancerProfile.jobTitle;
        }
        if (user.freelancerProfile.bio != null &&
            user.freelancerProfile.bio != '') {
          body['bio'] = user.freelancerProfile.bio;
        }
      }

      print(
        'Body ::',
      );
      print(body);

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

  /// get All asset provider
  static Future<Map> getAll(
      String accessToken, Map<String, dynamic> queryParams) async {
    try {
      var data = await RequestClient.get('user/getAll',
          headers: {'authorization': accessToken}, queryParams: queryParams);
      MetaData metaData = MetaData.fromJson(data['data']['metaData']);
      List<User> entries = [];
      for (var entry in data['data']['entries']) {
        entries.add(User.fromJson(entry));
      }

      print('Get All Users Data; ');
      print(data['data']['entries']);

      return {
        'entries': entries,
        'metaData': metaData,
      };
    } catch (exc) {
      print('exc here in get all assets');
      print(exc);
      throw exc;
    }
  }
}
