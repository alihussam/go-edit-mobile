import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goedit/blocs/job_page_bloc.dart';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/models/bid.dart';
import 'package:goedit/models/job.dart';
import 'package:goedit/repositories/job.dart';
import 'package:goedit/utils/request_exception.dart';
import 'package:rxdart/rxdart.dart';

class JobDetailsBloc {
  GlobalKey<ScaffoldState> _key;
  BehaviorSubject<bool> _isBidCreatingController;
  BehaviorSubject<Bid> _newBidController;

  Stream get bid => _newBidController.stream;
  Stream get isCreatingBid => _isBidCreatingController.stream;

  init(GlobalKey<ScaffoldState> _key, Job job) {
    this._key = _key;
    _newBidController = BehaviorSubject<Bid>();
    _isBidCreatingController = BehaviorSubject<bool>();
    // here check if my bid is already present here
    for (Bid b in job.bids) {
      if (mainBloc.userProfileObject.sId == b.user.sId) {
        _newBidController.sink.add(b);
      }
    }
  }

  dispose() {
    _isBidCreatingController.close();
    _newBidController.close();
  }

  /// show alert message
  alert(String message) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  isJobOfCurrentUser(Job job) {
    return job.user.sId == mainBloc.userProfileObject.sId;
  }

  createBid(Bid bid) async {
    try {
      _isBidCreatingController.sink.add(true);
      var data = await JobRepo.bid(bid);
      _isBidCreatingController.sink.add(false);
      _newBidController.sink.add(data['bid']);
      // refresh previous job page
      jobPageBloc.refetchPreviousJobs();
    } catch (error) {
      if (error is RequestException) {
        alert(error.message);
      } else {
        alert(error.toString());
      }
      _isBidCreatingController.sink.add(false);
    }
  }
}

final jobDetailsBloc = JobDetailsBloc();
