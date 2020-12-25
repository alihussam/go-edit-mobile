import 'dart:convert';
import 'dart:io';

import 'package:goedit/utils/request_exception.dart';
import 'package:http/http.dart' as http;

class RequestClient {
  static const Map _HTTP_HEADERS = {
    'accept': 'application/json',
    'content-type': 'application/json'
  };

  // post request send
  static Future get(String url,
      {Map<String, String> headers, Map<String, dynamic> queryParams}) async {
    try {
      // create custom header object if one arrives
      Map<String, String> newheaders = Map.from(_HTTP_HEADERS);
      if (headers != null) {
        newheaders.addAll(headers);
      }
      Uri finalUrl = Uri(
        scheme: 'https',
        host: 'goedit.herokuapp.com',
        path: 'api/$url',
        queryParameters: queryParams,
      );

      var res = await http.get(
        finalUrl.toString(),
        headers: newheaders,
      );
      // check if any error occured
      if (res.statusCode != 200) {
        throw new RequestException(json.decode(res.body)['errorKey'],
            json.decode(res.body)['message']);
      }
      // return decoded json body
      return json.decode(res.body);
    } catch (exc) {
      print('exc here in request client');
      print(exc);
      // check if we made this exception ourselve
      if (exc is RequestException) throw exc;
      // some unkown problem occured check type
      exc.toString().contains('SocketException')
          ? throw new RequestException('NETWORK_ISSUE',
              'Unable to connect to internet. Please check your internet connection and try again.')
          : throw new RequestException('UNKOWN_PROBLEM', exc.toString());
    }
  }

  // post request send
  static Future post(String url,
      {Map<String, String> headers, String jsonEncodedBody}) async {
    try {
      // create custom header object if one arrives
      Map<String, String> newheaders = Map.from(_HTTP_HEADERS);
      if (headers != null) {
        newheaders.addAll(headers);
      }

      var res = await http.post('https://goedit.herokuapp.com/api/' + url,
          headers: newheaders,
          body: jsonEncodedBody != null ? jsonEncodedBody : null);
      // check if any error occured
      if (res.statusCode != 200) {
        throw new RequestException(json.decode(res.body)['errorKey'],
            json.decode(res.body)['message']);
      }
      // return decoded json body
      return json.decode(res.body);
    } catch (exc) {
      print(exc.toString());
      // check if we made this exception ourselve
      if (exc is RequestException) throw exc;
      // some unkown problem occured check type
      exc.toString().contains('SocketException')
          ? throw new RequestException('NETWORK_ISSUE',
              'Unable to connect to internet. Please check your internet connection and try again.')
          : throw new RequestException('UNKOWN_PROBLEM', exc.toString());
    }
  }

  static Future postMultiPart(String url,
      {Map<String, String> headers,
      Map<String, String> payload,
      List<File> files}) async {
    try {
      var req = http.MultipartRequest(
          'POST', Uri.parse('https://goedit.herokuapp.com/api/${url}'));

      if (headers != null) {
        req.headers.addAll(headers);
      }

      if (payload != null) {
        req.fields.addAll(payload);
      }

      if (files != null) {
        for (File file in files) {
          req.files.add(await http.MultipartFile.fromPath('files', file.path));
        }
      }

      var response = await req.send();
      var parsedResponse = await response.stream.bytesToString();
      var data = json.decode(parsedResponse);

      if (response.statusCode != 200) {
        throw new RequestException(data['errorKey'], data['message']);
      }

      return data;
    } catch (exc) {
      print(exc.toString());
      // check if we made this exception ourselve
      if (exc is RequestException) throw exc;
      // some unkown problem occured check type
      exc.toString().contains('SocketException')
          ? throw new RequestException('NETWORK_ISSUE',
              'Unable to connect to internet. Please check your internet connection and try again.')
          : throw new RequestException('UNKOWN_PROBLEM', exc.toString());
    }
  }
}
