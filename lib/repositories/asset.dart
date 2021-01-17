import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/providers/asset.dart';
import 'package:goedit/utils/request_exception.dart';

class AssetRepo {
  static final FlutterSecureStorage _secureStorage = new FlutterSecureStorage();

  /// create asset repo
  static Future<Map> create(Asset asset) async {
    try {
      // add token in headers
      String accessToken = await _secureStorage.read(key: 'accessToken');
      print('access token found in create asset repo ');
      print(accessToken);
      var data = await AssetProv.create(accessToken, asset);
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

  /// get all assets
  static Future<Map> getSingleAsset(String assetId) async {
    try {
      // add token in headers
      String accessToken = await _secureStorage.read(key: 'accessToken');
      var data = await AssetProv.getSingleAsset(accessToken, assetId);
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

  static Future<Map> updateResource(String assetId, File file) async {
    try {
      // add token in headers
      String accessToken = await _secureStorage.read(key: 'accessToken');
      var data = await AssetProv.updateResource(accessToken, assetId, file);
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

  /// get all assets
  static Future<Map> getAll(Map<String, dynamic> queryParams) async {
    try {
      // add token in headers
      String accessToken = await _secureStorage.read(key: 'accessToken');
      var data = await AssetProv.getAll(accessToken, queryParams);
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
