import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/providers/user.dart';
import 'package:goedit/utils/request_exception.dart';

class UserRepo {
  static final FlutterSecureStorage _secureStorage = new FlutterSecureStorage();

  /// update profile repo
  static Future<Map> updateProfile(User user) async {
    try {
      // add token in headers
      String accessToken = await _secureStorage.read(key: 'accessToken');
      print('access token found in updateProfile repo ');
      print(accessToken);
      var data = await UserProv.updateProfile(accessToken, user);
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
}
