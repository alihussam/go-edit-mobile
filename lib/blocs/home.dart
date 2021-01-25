import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/asset.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/metaData.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/asset.dart';
import 'package:goedit/repositories/job.dart';
import 'package:goedit/repositories/user.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class HomeBloc {
  BehaviorSubject<int> _activePageController;
  BehaviorSubject<bool> _isLoadingAssetsController;
  BehaviorSubject<MetaData> _assetMetaDataController;
  BehaviorSubject<List<Asset>> _assetsController;
  BehaviorSubject<List<Job>> _jobsController;
  BehaviorSubject<MetaData> _usersMetaDataController;
  BehaviorSubject<List<User>> _usersController;
  BehaviorSubject<bool> _isLoadingUsersController;

  Stream get activePageIndex => _activePageController.stream;
  Stream get userProfile => mainBloc.userProfile;
  Stream get assets => _assetsController.stream;
  Stream get assetsMetaData => _assetMetaDataController.stream;
  Stream get isLoadingAssets => _isLoadingAssetsController.stream;
  Stream get users => _usersController.stream;
  Stream get usersMetaData => _usersMetaDataController.stream;
  Stream get isLoadingUsers => _isLoadingUsersController.stream;
  Stream get jobs => _jobsController.stream;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// init home bloc
  init() {
    _activePageController = BehaviorSubject<int>();
    _isLoadingAssetsController = BehaviorSubject<bool>();
    _assetMetaDataController = BehaviorSubject<MetaData>();
    _assetsController = BehaviorSubject<List<Asset>>();
    _jobsController = BehaviorSubject<List<Job>>();
    _usersMetaDataController = BehaviorSubject<MetaData>();
    _usersController = BehaviorSubject<List<User>>();
    _isLoadingUsersController = BehaviorSubject<bool>();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('flutter_devs');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: (String value) {});

    mainBloc.socket.on('notification_${mainBloc.userProfileObject.sId}',
        (data) {
      print('hahahah');
      showNotification(data['title'] ?? 'New Message', data['text'] ?? '');
    });
  }

  showNotification(String title, String body) async {
    print('hereeeeeeeeeeeeeeeeeeeee');
    var android = AndroidNotificationDetails('id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,
        payload: 'Welcome to the Local Notification demo');
  }

  changeActivePage(int index) {
    _activePageController.add(index);
  }

  getAllAssets({String searchString, String user, int limit, int page}) async {
    _isLoadingAssetsController.add(true);
    try {
      // construct query first
      Map<String, dynamic> queryParams = {};
      if (searchString != null) queryParams['searchString'] = searchString;
      if (user != null) queryParams['user'] = user;
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;

      // make the call
      var res = await AssetRepo.getAll(queryParams);
      List<Asset> _finalList = res['entries'];
      _finalList = _finalList.map((e) {
        e.isCurrentUsersAsset = (e.user.sId == mainBloc.user.sId);
        return e;
      }).toList();
      _assetsController.add(_finalList);
      _assetMetaDataController.add(res['metaData']);
      _isLoadingAssetsController.add(false);
    } catch (exc, stacktrace) {
      var completer = Completer();
      completer.completeError(exc, stacktrace);
      _isLoadingAssetsController.add(false);

      /// check if error was due to auth token
      if (exc is RequestException) {
        if (exc.errorKey == 'JWT_MISSING' ||
            exc.errorKey == 'JWT_EXPIRED' ||
            exc.errorKey == 'JWT_INVALID') {
          mainBloc.logout();
        }
        alert(exc.message);
      } else {
        alert(exc.toString());
      }
    }
  }

  getAllJobs({String searchString, String user, int limit, int page}) async {
    _isLoadingAssetsController.add(true);
    try {
      // construct query first
      Map<String, dynamic> queryParams = {
        'status': 'PENDING',
      };
      // if (searchString != null) queryParams['searchString'] = searchString;
      // if (user != null) queryParams['user'] = user;
      // if (limit != null) queryParams['limit'] = limit;
      // if (page != null) queryParams['page'] = page;

      // make the call
      var res = await JobRepo.getAll(queryParams);
      List<Job> _finalList = res['entries'];
      // _finalList = _finalList.map((e) {
      //   e.isCurrentUsersAsset = (e.user.sId == mainBloc.user.sId);
      //   return e;
      // }).toList();
      _jobsController.add(_finalList);
      // _assetMetaDataController.add(res['metaData']);
      _isLoadingAssetsController.add(false);
    } catch (exc, stacktrace) {
      var completer = Completer();
      completer.completeError(exc, stacktrace);
      _isLoadingAssetsController.add(false);

      /// check if error was due to auth token
      if (exc is RequestException) {
        if (exc.errorKey == 'JWT_MISSING' ||
            exc.errorKey == 'JWT_EXPIRED' ||
            exc.errorKey == 'JWT_INVALID') {
          mainBloc.logout();
        }
        alert(exc.message);
      } else {
        alert(exc.toString());
      }
    }
  }

  getTopRatedUsers({String searchString, int limit, int page}) async {
    _isLoadingUsersController.add(true);
    try {
      // construct query first
      Map<String, dynamic> queryParams = {
        'sortField': 'freenlancerProfile.rating',
        'page': '1',
        'limit': '10',
      };

      // if (searchString != null) queryParams['searchString'] = searchString;
      // if (limit != null) queryParams['limit'] = limit;
      // if (page != null) queryParams['page'] = page;

      // make the call
      var res = await UserRepo.getAll(queryParams);
      _usersController.add(res['entries']);
      _usersMetaDataController.add(res['metaData']);
    } catch (exc, stacktrace) {
      var completer = Completer();
      completer.completeError(exc, stacktrace);

      /// check if error was due to auth token
      if (exc is RequestException) {
        if (exc.errorKey == 'JWT_MISSING' ||
            exc.errorKey == 'JWT_EXPIRED' ||
            exc.errorKey == 'JWT_INVALID') {
          mainBloc.logout();
        }
        alert(exc.message);
      } else {
        alert(exc.toString());
      }
    } finally {
      _isLoadingUsersController.add(false);
    }
  }

  /// show alert message
  alert(String message) => mainBloc.alert(message);

  /// close all the opened streams
  dispose() {
    _usersMetaDataController.close();
    _usersController.close();
    _isLoadingUsersController.close();
    _activePageController.close();
    _assetsController.close();
    _assetMetaDataController.close();
    _isLoadingAssetsController.close();
    mainBloc.socket.off('notification_${mainBloc.userProfileObject.sId}');
  }

  // logout user
  logout() => mainBloc.logout();
}

final HomeBloc homeBloc = HomeBloc();
