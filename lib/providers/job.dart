import 'dart:convert';
import 'package:goedit/models/bid.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/metaData.dart';
import 'package:goedit/utils/request.dart';

class JobProv {
  static Future<Map> create(
    String accessToken,
    Job job,
  ) async {
    try {
      var data = await RequestClient.post('jobs/create',
          headers: {'authorization': accessToken},
          jsonEncodedBody: json.encode(job.toJson()));
      return {'job': Job.fromJson(data['data'])};
    } catch (exc) {
      print('exc here in create job');
      print(exc);
      throw exc;
    }
  }

  static Future<Map> bid(
    String accessToken,
    Bid bid,
  ) async {
    try {
      print(json.encode(bid.toJson()));
      var data = await RequestClient.post('jobs/bid',
          headers: {'authorization': accessToken},
          jsonEncodedBody: json.encode(bid.toJson()));
      return {'bid': Bid.fromJson(data['data'])};
    } catch (exc) {
      print('exc here in create job');
      print(exc);
      throw exc;
    }
  }

  static Future<Map> bidAction(
    String accessToken,
    Map<String, String> payload,
  ) async {
    try {
      var data = await RequestClient.post('jobs/bidAction',
          headers: {'authorization': accessToken},
          jsonEncodedBody: json.encode(payload));
      return {'job': Job.fromJson(data['data'])};
    } catch (exc) {
      print('exc here in bid action job');
      print(exc);
      throw exc;
    }
  }

  static Future<Map> jobAction(
    String accessToken,
    Map<String, String> payload,
  ) async {
    try {
      var data = await RequestClient.post('jobs/jobAction',
          headers: {'authorization': accessToken},
          jsonEncodedBody: json.encode(payload));
      return {'job': Job.fromJson(data['data'])};
    } catch (exc) {
      print('exc here in bid action job');
      print(exc);
      throw exc;
    }
  }

  /// get All Jobs provider
  static Future<Map> getAll(
      String accessToken, Map<String, dynamic> queryParams) async {
    try {
      var data = await RequestClient.get('jobs/getAll',
          headers: {'authorization': accessToken}, queryParams: queryParams);
      MetaData metaData = MetaData.fromJson(data['data']['metaData']);
      List<Job> entries = [];
      for (var entry in data['data']['entries']) {
        entries.add(Job.fromJson(entry));
        // print(entry);
        // print('***********88');
      }

      return {
        'entries': entries,
        'metaData': metaData,
      };
    } catch (exc) {
      print('exc here in get all jobs');
      print(exc);
      throw exc;
    }
  }
}
