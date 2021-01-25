import 'dart:convert';
import 'package:goedit/models/user.dart';
import 'package:goedit/utils/request.dart';

class AuthProv {
  /// Signup user provider
  static Future<Map> signup(User user) async {
    try {
      var data = await RequestClient.post('auth/signup',
          jsonEncodedBody: json.encode(user.toJson()));

      return {
        'profile': User.fromJson(data['data']['profile']),
        'accessToken': data['data']['token'],
      };
    } catch (exc) {
      print('in signup prov ');
      print(exc.toString());
      throw exc;
    }
  }

  /// Login user provider
  static Future<Map> login(String email, String password) async {
    try {
      var data = await RequestClient.post('auth/login',
          jsonEncodedBody: json
              .encode({'role': 'USER', 'email': email, 'password': password}));

      print('User Profile ***************');
      print(data['data']['profile']);

      return {
        'profile': User.fromJson(data['data']['profile']),
        'accessToken': data['data']['token'],
      };
    } catch (exc) {
      throw exc;
    }
  }

  /// Login user provider
  static Future<Map> getProfile(
      String accessToken, Map<String, dynamic> queryParams) async {
    try {
      var data = await RequestClient.get('auth/getProfile',
          headers: {'authorization': accessToken},
          queryParams: queryParams != null ? queryParams : {});
      return {'profile': User.fromJson(data['data'])};
    } catch (exc) {
      print('exc here in get profile');
      print(exc);
      throw exc;
    }
  }
}
