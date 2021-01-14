import 'dart:async';
import 'dart:io';

import 'package:goedit/models/asset.dart';
import 'package:goedit/models/metaData.dart';
import 'package:goedit/utils/request.dart';

class AssetProv {
  static Future<Map> create(
    String accessToken,
    Asset asset,
  ) async {
    try {
      Map<String, String> headers = {'authorization': accessToken};
      Map<String, String> body = Map<String, String>();
      List<File> files = List<File>();

      if (asset.imageFile != null) {
        files.add(asset.imageFile);
      }

      // convert map to string, string
      asset.toJson().forEach((key, value) => body[key] = value?.toString());

      var data = await RequestClient.postMultiPart('asset/create',
          headers: headers, payload: body, files: files);

      return {'asset': Asset.fromJson(data['data'])};
    } catch (exc, stacktrace) {
      var completer = Completer();
      completer.completeError(exc, stacktrace);
      print('exc here in create asset');
      print(exc);
      throw exc;
    }
  }

  /// get All asset provider
  static Future<Map> getAll(
      String accessToken, Map<String, dynamic> queryParams) async {
    try {
      var data = await RequestClient.get('asset/getAll',
          headers: {'authorization': accessToken}, queryParams: queryParams);
      MetaData metaData = MetaData.fromJson(data['data']['metaData']);
      List<Asset> entries = [];
      for (var entry in data['data']['entries']) {
        entries.add(Asset.fromJson(entry));
      }

      print('Get All Assets Data; ');
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
