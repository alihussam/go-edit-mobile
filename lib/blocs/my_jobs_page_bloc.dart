import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/metaData.dart';
import 'package:goedit/repositories/job.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class MyJobsPageBloc {
  BehaviorSubject<bool> _isLoadingJobsController;
  BehaviorSubject<MetaData> _jobsMetaDataController;
  BehaviorSubject<List<Job>> _jobsController;
  BehaviorSubject<bool> _isCreatingJobController;
  BehaviorSubject<Job> _newJobController;

  Stream get jobs => _jobsController.stream;
  Stream get jobsMetaData => _jobsMetaDataController.stream;
  Stream get isLoadingJobs => _isLoadingJobsController.stream;
  Stream get isCreatingJob => _isCreatingJobController.stream;
  Stream get job => _newJobController.stream;

  init() {
    _jobsController = BehaviorSubject<List<Job>>();
    _jobsMetaDataController = BehaviorSubject<MetaData>();
    _isLoadingJobsController = BehaviorSubject<bool>();
    _isCreatingJobController = BehaviorSubject<bool>();
    _newJobController = BehaviorSubject<Job>();
  }

  getAllJobs({String searchString, String user, int limit, int page}) async {
    _isLoadingJobsController.add(true);
    try {
      // construct query first
      Map<String, dynamic> queryParams = {};
      if (searchString != null) queryParams['searchString'] = searchString;
      if (user != null) queryParams['user'] = mainBloc.userProfileObject.sId;
      if (limit != null) queryParams['limit'] = limit;
      if (page != null) queryParams['page'] = page;

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

  createJob(Job job) async {
    try {
      _isCreatingJobController.sink.add(true);
      var data = await JobRepo.create(job);
      _newJobController.sink.add(data['job']);
    } catch (error) {
      if (error is RequestException) {
        _newJobController.sink.addError(error.message);
      } else {
        _newJobController.sink.addError(error.toString());
      }
    } finally {
      _isCreatingJobController.sink.add(false);
    }
  }

  /// show alert message
  alert(String message) => mainBloc.alert(message);

  /// close all the opened streams
  dispose() {
    _isCreatingJobController.close();
    _newJobController.close();
    _jobsController.close();
    _jobsMetaDataController.close();
    _isLoadingJobsController.close();
  }
}

final MyJobsPageBloc myJobsPageBloc = MyJobsPageBloc();
