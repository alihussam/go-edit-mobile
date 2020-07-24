import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _secureStorage = new FlutterSecureStorage();

  Future<String> read(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  Future<List> readMultiple(List<String> keys) async {
    List<String> _ = [];
    for (String key in keys) {
      _.add(await read(key));
    }
    return _;
  }

  write(String key, String value) async =>
      _secureStorage.write(key: key, value: value);

  writeMultiple(Map map) async =>
      map.forEach((k, v) => _secureStorage.write(key: k, value: v));
      
  remove(String key) async => _secureStorage.delete(key: key);

  removeMultiple(List<String> keys) async =>
      keys.forEach((key) => _secureStorage.delete(key: key));
}

final SecureStorage secureStorage = new SecureStorage();
