import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goedit/providers/job.dart';
import 'package:goedit/utils/request_exception.dart';

class JobRepo {
  static final FlutterSecureStorage _secureStorage = new FlutterSecureStorage();

  /// get all jobs
  static Future<Map> getAll(Map<String, dynamic> queryParams) async {
    try {
      // add token in headers
      String accessToken = await _secureStorage.read(key: 'accessToken');
      var data = await JobProv.getAll(accessToken, queryParams);
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
