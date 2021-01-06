import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/metaData.dart';
import 'package:goedit/repositories/job.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class JobPageBloc {
  BehaviorSubject<bool> _isLoadingJobsController;
  BehaviorSubject<MetaData> _jobsMetaDataController;
  BehaviorSubject<List<Job>> _jobsController;

  Map<String, dynamic> lastUsedQuery = {};

  Stream get jobs => _jobsController.stream;
  Stream get jobsMetaData => _jobsMetaDataController.stream;
  Stream get isLoadingJobs => _isLoadingJobsController.stream;

  init() {
    _jobsController = BehaviorSubject<List<Job>>();
    _jobsMetaDataController = BehaviorSubject<MetaData>();
    _isLoadingJobsController = BehaviorSubject<bool>();
  }

  refetchPreviousJobs() async {
    _isLoadingJobsController.add(true);
    try {
      // make the call
      var res = await JobRepo.getAll(lastUsedQuery);
      _jobsController.add(res['entries']);
      _jobsMetaDataController.add(res['metaData']);
      _isLoadingJobsController.add(false);
    } catch (exc) {
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

  getAllJobs({String searchString, String user, int limit, int page}) async {
    _isLoadingJobsController.add(true);
    try {
      // construct query first
      Map<String, dynamic> queryParams = {};
      if (searchString != null) queryParams['searchString'] = searchString;
      if (user != null) queryParams['user'] = user;
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;

      lastUsedQuery = queryParams;

      // make the call
      var res = await JobRepo.getAll(queryParams);
      _jobsController.add(res['entries']);
      _jobsMetaDataController.add(res['metaData']);
      _isLoadingJobsController.add(false);
    } catch (exc) {
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
    _jobsMetaDataController.close();
    _isLoadingJobsController.close();
  }
}

final JobPageBloc jobPageBloc = JobPageBloc();
