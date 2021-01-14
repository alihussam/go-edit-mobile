import 'dart:async';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/user.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class DesignersPageBloc {
  BehaviorSubject<bool> _isLoadingJobsController;
  BehaviorSubject<List<User>> _jobsController;

  Map<String, dynamic> lastUsedQuery = {};

  Stream get users => _jobsController.stream;
  Stream get isLoadingUsers => _isLoadingJobsController.stream;

  init() {
    _jobsController = BehaviorSubject<List<User>>();
    _isLoadingJobsController = BehaviorSubject<bool>();
  }

  refetchPreviousUsers() async {
    _isLoadingJobsController.add(true);
    try {
      // make the call
      var res = await UserRepo.getAll(lastUsedQuery);
      _jobsController.add(res['entries']);
      _isLoadingJobsController.add(false);
    } catch (error, stacktrace) {
      var completer = Completer();
      completer.completeError(error, stacktrace);
      _isLoadingJobsController.add(false);

      /// check if error was due to auth token
      if (error is RequestException) {
        if (error.errorKey == 'JWT_MISSING' ||
            error.errorKey == 'JWT_EXPIRED' ||
            error.errorKey == 'JWT_INVALID') {
          mainBloc.logout();
        }
        alert(error.message);
      } else {
        alert(error.toString());
      }
    }
  }

  getAllUsers({String searchString, String user, int limit, int page}) async {
    _isLoadingJobsController.add(true);
    try {
      // construct query first
      // Map<String, dynamic> queryParams = {};
      Map<String, dynamic> queryParams = {
        'sortField': 'freenlancerProfile.rating',
        // 'page': '1',
        // 'limit': '10',
      };
      if (searchString != null) queryParams['searchString'] = searchString;
      // if (user != null) queryParams['user'] = user;
      // if (limit != null) queryParams['limit'] = limit;
      // if (page != null) queryParams['page'] = page;

      lastUsedQuery = queryParams;

      // make the call
      var res = await UserRepo.getAll(queryParams);
      _jobsController.add(res['entries']);
      _isLoadingJobsController.add(false);
    } catch (exc, stacktrace) {
      var completer = Completer();
      completer.completeError(exc, stacktrace);
      _isLoadingJobsController.add(false);

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

  /// show alert message
  alert(String message) => mainBloc.alert(message);

  /// close all the opened streams
  dispose() {
    _jobsController.close();
    _isLoadingJobsController.close();
  }
}

final designersPageBloc = DesignersPageBloc();
