import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/providers/auth.dart';
import 'package:goedit/utils/request_exception.dart';

class AuthRepo {
  static final FlutterSecureStorage _secureStorage = new FlutterSecureStorage();

  /// Signup user repo
  static Future<Map> signup(User user) async {
    try {
      var data = await AuthProv.signup(user);
      // safe token in secure store & return response
      print('in singup saving token');
      print(data['accessToken']);
      await _secureStorage.write(
          key: 'accessToken', value: data['accessToken']);
      return data;
    } catch (exc) {
      throw exc;
    }
  }

  /// login user repo
  static Future<Map> login(String email, String password) async {
    try {
      var data = await AuthProv.login(email, password);
      print('in login saving token');
      print(data['accessToken']);
      // safe token in secure store & return response
      await _secureStorage.write(
          key: 'accessToken', value: data['accessToken']);
      return data;
    } catch (exc) {
      throw exc;
    }
  }

  /// get profile repo
  static Future<Map> getProfile(Map<String, dynamic> queryParams) async {
    try {
      // add token in headers
      String accessToken = await _secureStorage.read(key: 'accessToken');
      print('access token found in getProfile repo ');
      print(accessToken);
      var data = await AuthProv.getProfile(accessToken, queryParams);
      return data;
    } catch (exc) {
      if (exc is RequestException) {
        // here we check if our error key is related to jwt
        if (exc.errorKey == 'JWT_MISSING' ||
            exc.errorKey == 'JWT_EXPIRED' ||
            exc.errorKey == 'JWT_INVALID') {
          _secureStorage.delete(key: 'accessToken');
        }
      }
      throw exc;
    }
  }

  /// logout user
  static void logout() async {
    try {
      _secureStorage.delete(key: 'accessToken');
    } catch (exc) {
      // ignore exception here
    }
  }
}
