import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/models/user.dart';
import 'package:goedit/repositories/job.dart';
import 'package:goedit/repositories/user.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/subjects.dart';

class CreateNewJobPageBloc {
  GlobalKey<ScaffoldState> _key;
  BehaviorSubject<bool> _isCreatingJobController;
  BehaviorSubject<Job> _newJobController;
  Stream get isCreatingJob => _isCreatingJobController.stream;
  Stream get job => _newJobController.stream;

  init(GlobalKey<ScaffoldState> _key) {
    this._key = _key;
    _isCreatingJobController = new BehaviorSubject<bool>();
    _newJobController = new BehaviorSubject<Job>();
    _isCreatingJobController.add(false);
  }

  /// show alert message
  alert(String message) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  /// close all the opened streams
  dispose() {
    _isCreatingJobController.close();
    _newJobController.close();
  }

  createJob(Job job) async {
    try {
      _isCreatingJobController.sink.add(true);
      var data = await JobRepo.create(job);
      _isCreatingJobController.sink.add(false);
      Timer(Duration(milliseconds: 400),
          () => _newJobController.sink.add(data['job']));
    } catch (error) {
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
      _isCreatingJobController.sink.add(false);
    }
  }
}

final createNewJobPageBloc = new CreateNewJobPageBloc();
