import 'dart:convert';
import 'package:goedit/models/bid.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/message.dart';
import 'package:goedit/models/chat.model.dart';
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
      return {'job': Job.fromJson(data['data'])};
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
      print('exc here in job action job');
      print(exc);
      throw exc;
    }
  }

  static Future<Map> provideRating(
    String accessToken,
    Map<String, String> payload,
  ) async {
    try {
      var data = await RequestClient.post('jobs/provideRating',
          headers: {'authorization': accessToken},
          jsonEncodedBody: json.encode(payload));
      return {'job': Job.fromJson(data['data'])};
    } catch (exc) {
      print('exc here in provide rating job');
      print(exc);
      throw exc;
    }
  }

  /// get All Jobs provider
  static Future<Map> getAll(
      String accessToken, Map<String, dynamic> queryParams) async {
    try {
      print('GetALll jobs query params');
      print(queryParams);
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

  // ************************
  // CHAT
  // ************************
  static Future<Map> createChatMessage(
    String accessToken,
    Message message,
  ) async {
    try {
      var data = await RequestClient.post('chat/create',
          headers: {'authorization': accessToken},
          jsonEncodedBody: json.encode(message.toJson()));
      return {'message': Message.fromJson(data['data'])};
    } catch (exc) {
      print('exc here in create message');
      print(exc);
      throw exc;
    }
  }

  /// get All Jobs provider
  static Future<Map> getAllMessages(
      String accessToken, Map<String, dynamic> queryParams) async {
    try {
      print('GetALll messages query params');
      print(queryParams);
      var data = await RequestClient.get('chat/getAllMessages',
          headers: {'authorization': accessToken}, queryParams: queryParams);
      List<Message> entries = [];
      for (var entry in data['data']) {
        entries.add(Message.fromJson(entry));
      }

      return {
        'entries': entries,
      };
    } catch (exc) {
      print('exc here in get chats');
      print(exc);
      throw exc;
    }
  }

  /// get All Jobs provider
  static Future<Map> getAllChats(
      String accessToken, Map<String, dynamic> queryParams) async {
    try {
      print('GetALll chats query params');
      print(queryParams);
      var data = await RequestClient.get('chat/getAll',
          headers: {'authorization': accessToken}, queryParams: queryParams);
      MetaData metaData = MetaData.fromJson(data['data']['metaData']);
      List<Chat> entries = [];
      for (var entry in data['data']['entries']) {
        entries.add(Chat.fromJson(entry));
      }

      return {
        'entries': entries,
        'metaData': metaData,
      };
    } catch (exc) {
      print('exc here in get chats');
      print(exc);
      throw exc;
    }
  }
}
