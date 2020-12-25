import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:goedit/models/asset.dart';
import 'package:goedit/models/metaData.dart';
import 'package:goedit/utils/request.dart';

class AssetProv {
  static Future<Map> create(
    String accessToken,
    Asset asset,
  ) async {
    try {
      var req = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.1.106:4041/api/asset/create'));

      req.headers.addAll({
        'authorization': accessToken,
        'Content-Type': 'multipart/form-data'
      });

      // create a request
      req.fields['title'] = asset.title.toString();
      req.fields['description'] = asset.description.toString();
      req.fields['currency'] = asset.currency.toString();
      req.fields['price'] = asset.price.toString();

      print('Payload');
      print(req.fields);

      // check if file
      if (asset.imageFile != null) {
        print('here');
        req.files.add(
          await http.MultipartFile.fromPath(
            'files',
            asset.imageFile.path,
          ),
        );
      }

      print('Request');
      print(req.toString());

      var response = await req.send();
      var parsedResponse = await response.stream.bytesToString();
      var data = json.decode(parsedResponse);

      if (response.statusCode != 200) {
        print('Data:::');
        print(data);
        throw data['message'];
      }

      // var data = await RequestClient.post('asset/create',
      //     headers: {'authorization': accessToken},
      //     jsonEncodedBody: json.encode(asset.toJson()));
      return {'asset': Asset.fromJson(data['data'])};
    } catch (exc) {
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
