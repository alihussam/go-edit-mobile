import 'dart:convert';

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
        // scheme: 'https',
        // host: 'goedit.herokuapp.com',
        scheme: 'http',
        host: '192.168.1.106',
        port: 4041,
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
      // https://goedit.herokuapp.com/api/
      var res = await http.post('http://192.168.1.106:4041/api/' + url,
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
}
